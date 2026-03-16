import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/View/Auth/login_screen.dart';
import '../Helper/app_const.dart';
import '../ViewModel/settings_view_model.dart';
import '../ViewModel/user_view_model.dart';

/// The first screen shown when the app launches.
///
/// Displays the app logo briefly while attempting to restore a previous
/// session via [UserViewModel.initUser]:
/// * If a valid token is found, the user is fetched from the API and the
///   app navigates to [Routes.HOME].
/// * If no token exists, the app navigates to [LoginScreen] (or the
///   language-selection screen on first run).
///
/// Also handles the "new version available" flow by showing an update dialog
/// when [UserViewModel.isNewVersion] is `true`.
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
