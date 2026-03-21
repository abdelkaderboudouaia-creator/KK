import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../Helper/app_const.dart';
import '../../../ViewModel/settings_view_model.dart';
import '../../../ViewModel/user_view_model.dart';
import '../ViewModel/auth_view_model.dart';
import '/View/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Widgets/custom_profile_pic.dart';
import 'Widgets/custom_text_field.dart';
import 'Widgets/phone_number_field.dart';

/// Screen that allows the authenticated user to change their account password.
///
/// The user must supply their [currentPassword] and a [newPassword]
/// (confirmed by a second field).  On submission the request is forwarded to
/// [AuthViewModel.changePassword].  A loading overlay is displayed while the
/// API call is pending.
class ChangePassword extends StatefulWidget {
  const ChangePassword({
    super.key,
  });

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
  final AuthViewModel authViewModel = Get.put(AuthViewModel());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Change Password'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GetBuilder<AuthViewModel>(
        builder: (_) {
          return ModalProgressHUD(
            inAsyncCall: authViewModel.loading,
            progressIndicator: CircularProgressIndicator(
              color: AppConst.primaryColor,
            ),
            opacity: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 15,),
                      CustomTextField(
                        hintText: 'Current password'.tr,
                        textEditingController: currentPasswordController,
                        inputType: TextInputType.visiblePassword,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
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
                        text: 'Update'.tr,
                        onPressed: () async{
                          if (formKey.currentState!.validate()) {
                            await authViewModel.changePassword(currentPassword: currentPasswordController.text, newPassword: newPasswordController.text);
                          }

                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



