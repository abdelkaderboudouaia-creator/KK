import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/app_routes.dart';
import '../ViewModel/settings_view_model.dart';
import '../Helper/app_const.dart';
import '../ViewModel/user_view_model.dart';


class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key});


  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Get.find<UserViewModel>();


    return Scaffold(
      appBar: Navigator.of(context).canPop() ? AppBar(
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
          'Language'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose your Language'.tr,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BalooBhaijaan2'
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Select the language you prefer to use in the app'.tr,
              style: TextStyle(
                  fontSize: 16,
                  color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'BalooBhaijaan2'
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            LanguageButton(
              language: 'العربية',
              languageCode: 'ar',
              flag: '🇶🇦',
              onTap: () async {
                await Get.find<SettingsViewModel>().setLocal('ar');
                if(AppConst.prefs.getString('token') != null){
                  if(userViewModel.user != null){
                    userViewModel.updateUser(language: 'ar');
                  }
                  Get.offNamed(Routes.PROFILE);
                }
                else {
                  Get.toNamed(Routes.LOGIN);
                }
              },
            ),
            const SizedBox(height: 16),
            LanguageButton(
              language: 'English',
              languageCode: 'en',
              flag: '🇺🇸',
              onTap: () async {
                await Get.find<SettingsViewModel>().setLocal('en');
                if(AppConst.prefs.getString('token') != null){
                  if(userViewModel.user != null){
                    userViewModel.updateUser(language: 'en');
                  }
                  Get.offNamed(Routes.PROFILE);
                }
                else {
                  Get.toNamed(Routes.LOGIN);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String language;
  final String languageCode;
  final String flag;
  final VoidCallback onTap;

  const LanguageButton({
    required this.language,
    required this.languageCode,
    required this.flag,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Get.isDarkMode ? Colors.white : Colors.grey.shade300,
            width: 1,
          ),
        ),
        elevation: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            flag,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'BalooBhaijaan2'
            ),
          ),
          const SizedBox(width: 16),
          Text(
            language,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
                fontFamily: 'BalooBhaijaan2'
            ),
          ),
        ],
      ),
    );
  }
}
