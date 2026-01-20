import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Helper/app_const.dart';
import '../Helper/app_routes.dart';

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