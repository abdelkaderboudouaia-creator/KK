import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'app_const.dart';


class ThemeService {

  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  Future<void> switchTheme() async{
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await AppConst.prefs.setBool(_key, !Get.isDarkMode);
  }

  bool _loadTheme() => AppConst.prefs.getBool(_key) ?? (SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

}

