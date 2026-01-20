import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/View/Auth/login_screen.dart';
import '../Helper/app_const.dart';
import '../ViewModel/settings_view_model.dart';
import '../ViewModel/user_view_model.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SettingsViewModel settingsViewModel = Get.find<SettingsViewModel>();
  final UserViewModel userViewModel = Get.find<UserViewModel>();



  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async{
      if(AppConst.prefs.getString('local') != null){
        await userViewModel.getUser();
      }
      else{
        Get.offNamed('/language-selection');
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
