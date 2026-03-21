import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qplay/Helper/app_routes.dart';
import 'package:qplay/Helper/theme_service.dart';

import '../../../Helper/app_const.dart';
import '../../../ViewModel/auth_view_model.dart';
import '../../../ViewModel/settings_view_model.dart';
import '../../../ViewModel/user_view_model.dart';
import '../../Widgets/custom_profile_pic.dart';
import '../Widgets/custom_dialog.dart';

/// Profile tab – shows the authenticated user's profile information and
/// app settings.
///
/// Displays the avatar ([CustomProfilePic]), full name, and menu items:
/// * Edit Profile   → [Routes.EDIT_PROFILE]
/// * Wallet         → [Routes.WALLET]
/// * Change Password→ [Routes.CHANGE_PASSWORD]
/// * Language       → [Routes.LANGUAGE]
/// * Privacy Policy → [Routes.PRIVACY_POLICY]
/// * Help Center    → [Routes.HELP_CENTER]
/// * Dark/Light mode toggle ([ThemeService.switchTheme])
/// * Logout (calls [AuthViewModel.logout] after a confirmation dialog)
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
  final UserViewModel userViewModel = Get.put(UserViewModel());
  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsViewModel>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const SizedBox.shrink(),
          title: Text(
            'Profile'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: GetBuilder<UserViewModel>(
          builder: (_) {
            if(userViewModel.isLoggedIn)
            return ModalProgressHUD(
              inAsyncCall: authViewModel.loading,
              progressIndicator: CircularProgressIndicator(
                color: AppConst.secondaryColor,
              ),
              opacity: 0,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      CustomProfilePic(
                        url: userViewModel.user!.photo,
                        size: MediaQuery.of(context).size.width / 3.5,
                        name: userViewModel.user!.firstName[0],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${userViewModel.user!.firstName} ${userViewModel.user!.lastName}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${userViewModel.user!.countryCode}${userViewModel.user!.phone}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      buildProfileButton(
                          icon: Icons.person_outline,
                          text: 'Edit Profile',
                          onTap: () {
                            Get.toNamed('/edit-profile');
                          }),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Get.toNamed('/language-selection');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.language_outlined,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Language'.tr,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    Get.locale!.languageCode,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Directionality(
                                    textDirection:
                                        Get.locale!.languageCode == 'ar'
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.visibility_outlined,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Dark Mode'.tr,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: Get.isDarkMode,
                              activeColor: AppConst.primaryColor,
                              onChanged: (value) async {
                                await ThemeService().switchTheme();
                                settingsViewModel.update();
                              },
                            )
                          ],
                        ),
                      ),
                      buildProfileButton(
                          icon: Icons.payment,
                          text: 'Wallet',
                          onTap: () {
                            Get.toNamed(Routes.WALLET);
                          },
                      ),
                      buildProfileButton(
                          icon: Icons.lock_outline,
                          text: 'Privacy Policy',
                          onTap: () {
                            Get.toNamed(Routes.PRIVACY_POLICY);
                          },
                      ),
                      buildProfileButton(
                          icon: Icons.help_outline,
                          text: 'Help Center',
                          onTap: () {
                            Get.toNamed(Routes.HELP_CENTER);
                          },
                      ),
                      buildProfileButton(
                        icon: CupertinoIcons.lock_rotation_open,
                        text: 'Change Password',
                        onTap: (){
                          Get.toNamed('/change-password');
                        },
                      ),
                      buildProfileButton(
                        icon: Icons.logout,
                        text: 'Logout',
                        onTap: () async {
                          showConfirmationDialog(
                            title: 'Logout',
                            text: 'Are you sure you want to logout ?'.tr,
                            onPressed: () async {
                              await authViewModel.logout();
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Q-Play version 1.0.0',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppConst.secondaryColor),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
            else
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: AppConst.secondaryColor, size: 60),
                    SizedBox(height: 16),
                    SizedBox(height: 8),
                    Text(
                      "Please sign in to continue".tr,
                      style: TextStyle(
                          color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed('/login');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppConst.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sign In'.tr,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );

          },
        ),
      );
    });
  }

  InkWell buildProfileButton(
      {required IconData icon,
      required String text,
      required Function()? onTap}) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text.tr,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Directionality(
              textDirection: Get.locale!.languageCode == 'ar'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
