import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qplay/View/Widgets/phone_number_field.dart';

import '../../ViewModel/auth_view_model.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_button.dart';
import '../Widgets/custom_text_field.dart';
import '/Helper/app_const.dart';

/// New user registration screen.
///
/// Collects first name, last name, email, phone number (via
/// [PhoneNumberField]), birthday, and password.  Pre-fills name and email
/// when the user arrives from the Google Sign-In flow (values are set on
/// [AuthViewModel] before navigation).
///
/// Submitting the form calls [AuthViewModel.register].
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final AuthViewModel authViewModel = Get.find<AuthViewModel>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController birthdayController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: authViewModel.firstName);
    lastNameController = TextEditingController(text: authViewModel.lastName);
    emailController = TextEditingController(text: authViewModel.email);
    phoneNumberController = TextEditingController();
    birthdayController = TextEditingController();
    passwordController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GetBuilder<AuthViewModel>(
              builder: (_) {
              return ModalProgressHUD(
                inAsyncCall: authViewModel.loading,
                progressIndicator: CircularProgressIndicator(
                  color: AppConst.primaryColor,
                ),
                opacity: 0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Create Account".tr,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign up to get started".tr,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 40),

                        // **Name Field**
                        CustomTextField(
                          hintText: "First Name".tr,
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                          textEditingController: firstNameController,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.length < 3) {
                              return 'Enter first name'.tr;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            authViewModel.firstName = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "Last Name".tr,
                          prefixIcon: const Icon(Icons.person_pin_outlined, color: Colors.grey),
                          textEditingController: lastNameController,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.length < 3) {
                              return 'Enter last name'.tr;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            authViewModel.lastName = value!;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          hintText: "Birthday".tr,
                          textEditingController: birthdayController,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000, 1, 1),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                          onSaved: (value){
                            if(value != null)
                            authViewModel.birthday = DateTime.tryParse(value);
                          },
                        ),
                        const SizedBox(height: 20),
                        PhoneNumberField(
                          controller: phoneNumberController,
                          initialCountryCode: '+974',
                          onSaved: (value) {
                            authViewModel.phone = value!.number;
                            authViewModel.countryCode = value.countryCode;
                          },
                        ),

                        CustomTextField(
                          hintText: "Email Address".tr,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                          textEditingController: emailController,
                          readOnly: emailController.text.isNotEmpty,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter email'.tr;
                            } else if (!GetUtils.isEmail(value)) {
                              return 'Wrong email'.tr;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            authViewModel.email = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "Password".tr,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                          textEditingController: passwordController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Enter password'.tr;
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters'
                                  .tr;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            authViewModel.password = value!;
                          },
                        ),
                        const SizedBox(height: 30),

                        CustomButton(
                          text: "Sign Up".tr,
                          onPressed: () async {
                            if (formKey.currentState!
                                .validate()) {
                              formKey.currentState!.save();

                              await authViewModel.register();
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? ".tr, style: TextStyle(fontSize: 14,)),
                            CustomTextButton(
                              onTap: () {
                                Get.toNamed('/login');
                              },
                              text: "Sign In".tr,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
