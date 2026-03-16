import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'app_const.dart';

/// Persists and restores the user's preferred [ThemeMode].
///
/// The theme preference is stored under the key `isDarkMode` in
/// [SharedPreferences] (via [AppConst.prefs]).  If no preference has been
/// saved, the service falls back to the platform's system brightness.
///
/// [switchTheme] toggles between light and dark mode and persists the new
/// value.  [theme] exposes the current [ThemeMode] to [MyApp].
class ThemeService {

  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  Future<void> switchTheme() async{
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await AppConst.prefs.setBool(_key, !Get.isDarkMode);
  }

  bool _loadTheme() => AppConst.prefs.getBool(_key) ?? (SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

}

