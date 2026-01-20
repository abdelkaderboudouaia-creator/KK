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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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





// main.dart or your main app widget
/*class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.toString());
    if (state == AppLifecycleState.resumed) {
      // Check for pending payments when app resumes
      _checkPendingPayments();
    }
  }

  Future<void> _checkPendingPayments() async {
    final paymentId = await SafePaymentService.getPendingPaymentId();
    if (paymentId != null) {
      // Check payment status
      final response = await PaymentApi.getPaymentStatus(paymentId);
      print('check pending payments');
      print(response);
      if (response['success'] == true) {
        final statusId = response['data']['statusId'];

        switch (statusId) {
          case 2: // Paid
            await SafePaymentService.clearPendingPayment();
            _showPaymentSuccess();
            break;
          case 3: // Canceled
          case 4: // Failed
            await SafePaymentService.clearPendingPayment();
            _showPaymentFailed();
            break;
        // For pending status, keep checking
        }
      }
    }
  }

  void _showPaymentSuccess() {
    // Show success message/navigate to success page
    print('success');
  }

  void _showPaymentFailed() {
    // Show failure message
  }

  @override
  Widget build(BuildContext context) {
    _checkPendingPayments();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payment Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Payment Example')),
        body: Center(
          child: ExternalBrowserPaymentButton(
            amount: 1.0,
            firstName: 'John',
            lastName: 'Doe',
            phone: '1234567890',
            email: 'john.doe@example.com',
            transactionId: 'TX123456',
            onPaymentInitiated: () {
              print('Payment process started');
            },
          ),
        ),
      ),
    );
  }
}


class ExternalBrowserPaymentButton extends StatelessWidget {
  final double amount;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String transactionId;
  final VoidCallback? onPaymentInitiated;

  const ExternalBrowserPaymentButton({
    Key? key,
    required this.amount,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.transactionId,
    this.onPaymentInitiated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        final success = await SafePaymentService.initiatePayment(
          amount: amount,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          transactionId: transactionId,
        );

        Navigator.of(context).pop(); // Close loading

        if (success) {
          onPaymentInitiated?.call();

          // Show instruction dialog
          _showPaymentInstructions(context);
        } else {
          _showErrorDialog(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.open_in_browser, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'Pay with SkipCash',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showPaymentInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Opened'),
        content: Text(
            'The payment page has been opened in your browser. '
                'Complete the payment and return to the app. '
                'We\'ll automatically detect when the payment is complete.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to initiate payment. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}*/