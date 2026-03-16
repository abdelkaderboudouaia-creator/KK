import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Helper/app_const.dart';
import '../Helper/app_routes.dart';

/// GetX controller that stores application-level settings.
///
/// Currently manages:
/// * **App locale** – [setLocal] persists the chosen language code to
///   [SharedPreferences] and calls [Get.updateLocale] so the UI rebuilds
///   with the new translations immediately.
/// * **Active navigation route** – [selectedRoute] / [setSelectedRoute]
///   allow the bottom navigation bar to highlight the correct tab and
///   navigate to it.
class SettingsViewModel extends GetxController {



  String selectedRoute = Routes.HOME;
  set setSelectedRoute(String route) {
    selectedRoute = route;
    Get.offAllNamed(route);
  }








  Future<void> setLocal(String languageCode) async{

    Get.updateLocale(Locale(languageCode));
    await AppConst.prefs.setString('local', languageCode);
  }



}