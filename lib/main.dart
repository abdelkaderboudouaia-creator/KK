import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/app_pages.dart';
import 'package:qplay/Helper/app_theme.dart';
import 'package:qplay/Helper/translate.dart';


import 'package:qplay/ViewModel/auth_view_model.dart';
import 'package:qplay/ViewModel/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Helper/app_const.dart';
import 'Helper/app_routes.dart';
import 'Helper/theme_service.dart';
import 'ViewModel/game_view_model.dart';
import 'ViewModel/notification_view_model.dart';
import 'ViewModel/settings_view_model.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _background(RemoteMessage message) async {
  try{
    try{
      AppConst.prefs = await SharedPreferences.getInstance();
    }
    catch(e){
      //
    }
    final NotificationViewModel notificationViewModel = Get.put(NotificationViewModel(),permanent: true);
    notificationViewModel.getNotification();
    String? title = message.data['title'];
    String? body = message.data['body'];
    Map<String, String> payload = {};
    if (message.data['payload'] != null) {
      final decoded = jsonDecode(message.data['payload']) as Map<String, dynamic>;
      payload = decoded.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        channelKey: 'notification',
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }
  catch(e){
    print(e.toString());
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'notification',
      channelName: 'Notification',
      channelDescription: 'Notification channel',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    )
  ]);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.setForegroundNotificationPresentationOptions(
    badge: true,
    sound: true,
    alert: true,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_background);
  FirebaseMessaging.onMessage.listen(_background);
  AppConst.prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = ThemeService();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Translate(),
      initialBinding: BindingsBuilder(() {
        Get.put(SettingsViewModel(), permanent: true);
        Get.put(AuthViewModel(), permanent: true);
        Get.put(UserViewModel(), permanent: true);
        Get.put(GameViewModel(), permanent: true);
        Get.put(NotificationViewModel(), permanent: true);

      }),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeService.theme,
      title: 'QPLay',
      locale: Locale(AppConst.prefs.getString('local') ?? 'ar'),
    );
  }
}
