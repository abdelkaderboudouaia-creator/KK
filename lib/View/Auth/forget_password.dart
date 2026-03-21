import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/settings_view_model.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_button.dart';
import '../Widgets/custom_text_field.dart';
import '/Helper/app_const.dart';

/// "Forgot password" screen – step 1 of the password-reset flow.
///
/// The user enters their registered email address and taps "Send".
/// [AuthViewModel.forgetPassword] is called which sends a reset code to
/// the email and, on success, navigates to [VerifyOtp] passing the
/// `resetId` returned by the backend.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetBuilder<AuthViewModel>(
          builder: (_) {
          return ModalProgressHUD(
            inAsyncCall: authViewModel.loading,
            progressIndicator: CircularProgressIndicator(
              color: AppConst.primaryColor,
            ),
            opacity: 0,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Forget password ?".tr,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter your email and we will send you an OTP to reset your password".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      CustomTextField(
                        hintText: "Email Address".tr,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email'.tr;
                          } else if (!GetUtils.isEmail(value)) {
                            return 'Wrong email'.tr;
                          }
                          return null;
                        },
                        onSaved: (value){
                          authViewModel.email = value!;
                        },

                      ),
                      const SizedBox(height: 30),

                      CustomButton(
                        text: "Send OTP".tr,
                        onPressed: () async{
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await authViewModel.forgetPassword();
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // **Back to Sign In**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Remember your password? ".tr, style: TextStyle(fontSize: 14)),
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
            ),
          );
        }
      ),
    );
  }
}
