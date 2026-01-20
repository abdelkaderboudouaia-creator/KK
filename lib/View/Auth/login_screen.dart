import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qplay/Helper/app_routes.dart';
import 'package:qplay/View/Widgets/login_with_social_media.dart';
import 'package:qplay/ViewModel/auth_view_model.dart';

import '../../ViewModel/settings_view_model.dart';
import '../Widgets/custom_text_button.dart';
import '/Helper/app_const.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AuthViewModel>(builder: (_) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        "Welcome Back!".tr,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to continue".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        hintText: "Email Address".tr,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.grey),
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
                        maxLines: 1,
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.grey),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password'.tr;
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters'
                                .tr
                                .tr;
                          }
                          return null;
                        },
                        onSaved: (value) {
                          authViewModel.password = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomTextButton(
                          onTap: () {
                            Get.toNamed('/forget-password');
                          },
                          text: "Forget password ?".tr,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Login".tr,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            await authViewModel.login();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                                color: Colors.grey.shade300, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR".tr,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: Colors.grey.shade300, thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LoginWithSocialMedia(
                        dark: Get.isDarkMode,
                        text: "Sign in with Google".tr,
                        onPressed: () async {
                          await authViewModel.loginWithGoogle();
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.HOME);
                        },
                        child: Text(
                          "Continue as Guest".tr,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ".tr,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          CustomTextButton(
                            onTap: () {
                              Get.toNamed('/register');
                            },
                            text: "Sign Up".tr,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
