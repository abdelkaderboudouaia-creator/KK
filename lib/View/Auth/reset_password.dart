import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Helper/app_const.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/settings_view_model.dart';
import '../../ViewModel/user_view_model.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());
  final UserViewModel userViewModel = Get.put(UserViewModel());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  bool loading = false;

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthViewModel>(
        builder: (_) {
          return Scaffold(
            body: SafeArea(
              child: ModalProgressHUD(
                inAsyncCall: authViewModel.loading,
                progressIndicator: CircularProgressIndicator(
                  color: AppConst.primaryColor,
                ),
                opacity: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            textEditingController: newPasswordController,
                            hintText: 'New password'.tr,
                            inputType: TextInputType.visiblePassword,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter password'.tr;
                              }
                              else if (value.length < 6) {
                                return 'Password must be at least 6 characters'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10,),
                          CustomTextField(
                            textEditingController: confirmPasswordController,
                            hintText: 'Confirm password'.tr,
                            inputType: TextInputType.visiblePassword,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter password'.tr;
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters'.tr;
                              }
                              else if(newPasswordController.text != confirmPasswordController.text){
                                return "Passwords do not match".tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          CustomButton(
                              text: 'Reset'.tr,
                              onPressed: () async{
                                if (formKey.currentState!.validate()) {
                                  await authViewModel.resetPassword(token: Get.parameters['token'] ?? 'token', newPassword: confirmPasswordController.text);
                                }
                              },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
