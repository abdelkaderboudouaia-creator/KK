import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/app_pages.dart';
import 'package:qplay/Helper/app_theme.dart';
import 'package:qplay/Helper/safe_payment_service.dart';
import 'package:qplay/Helper/translate.dart';
import 'package:qplay/ViewModel/Api/payment_api.dart';

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
/// Top-level FCM background/foreground message handler.
///
/// Called by [FirebaseMessaging.onBackgroundMessage] (when the app is
/// terminated or in the background) and by [FirebaseMessaging.onMessage]
/// (when the app is in the foreground).
///
/// The function:
/// 1. Re-initialises [SharedPreferences] if needed (background isolate).
/// 2. Refreshes the notification list via [NotificationViewModel].
/// 3. Displays a local OS notification via [AwesomeNotifications] using the
///    `title`, `body`, and optional `payload` fields from [message.data].
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
  runApp(MyApp());
}

/// The root widget of the QPlay application.
///
/// Configures the [GetMaterialApp] with:
/// * **Translations** – [Translate] (Arabic / English).
/// * **Initial bindings** – permanently registers all GetX controllers
///   ([SettingsViewModel], [AuthViewModel], [UserViewModel],
///   [GameViewModel], [NotificationViewModel]).
/// * **Routing** – [AppPages.routes] driven by [Routes] constants.
/// * **Theming** – [AppTheme.light] / [AppTheme.dark], with the active mode
///   read from [ThemeService].
/// * **Locale** – defaults to the language stored in [SharedPreferences]
///   (falls back to `ar`).
/// * **Lifecycle observer** – checks for any pending SkipCash payment each
///   time the app returns to the foreground (via [WidgetsBindingObserver]).
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called by the OS whenever the app lifecycle state changes.
  ///
  /// When the app is [AppLifecycleState.resumed] (i.e. the user has returned
  /// from the external browser), the pending payment status is re-checked so
  /// the wallet balance can be updated and the user receives feedback.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPendingPayments();
    }
  }

  /// Verifies the status of any payment that was opened in an external browser.
  ///
  /// If a `pending_payment_id` is found in [SharedPreferences] the backend is
  /// queried.  On a conclusive result (paid / cancelled / failed) the stored ID
  /// is cleared and a snackbar notifies the user.
  Future<void> _checkPendingPayments() async {
    final paymentId = await SafePaymentService.getPendingPaymentId();
    if (paymentId == null) return;

    final response = await PaymentApi.getPaymentStatus(paymentId);

    if (response['success'] == true) {
      final statusId = response['data']?['statusId'];

      switch (statusId) {
        case PaymentApi.statusPaid:
          await SafePaymentService.clearPendingPayment();
          _showPaymentSuccess();
          break;
        case PaymentApi.statusCancelled:
        case PaymentApi.statusFailed:
          await SafePaymentService.clearPendingPayment();
          _showPaymentFailed();
          break;
        // For a still-pending status keep the ID so we check again next time.
      }
    }
  }

  void _showPaymentSuccess() {
    Get.snackbar(
      'Payment Successful'.tr,
      'Your wallet has been topped up successfully.'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppConst.successColor,
      colorText: Colors.white,
    );
  }

  void _showPaymentFailed() {
    Get.snackbar(
      'Payment Failed'.tr,
      'Your payment could not be completed. Please try again.'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppConst.errorColor,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = ThemeService();
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
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