

import 'package:get/get.dart';
import 'package:qplay/View/Player/create_game_screen.dart';
import 'package:qplay/View/Player/help_center.dart';
import 'package:qplay/View/Player/privacy_policy.dart';
import 'package:qplay/View/Player/transaction_details.dart';
import 'package:qplay/View/Player/transactions.dart';
import 'package:qplay/View/Player/wallet.dart';
import 'package:qplay/ViewModel/user_view_model.dart';
import 'package:qplay/View/Player/navigator_screen.dart' as player;

import '../View/Auth/forget_password.dart';
import '../View/Auth/login_screen.dart';
import '../View/Auth/register_screen.dart';
import '../View/Auth/reset_password.dart';
import '../View/Auth/verify_otp.dart';
import '../View/Player/game_details.dart';
import '../View/change_password.dart';
import '../View/edit_profile.dart';
import '../View/language_selection.dart';
import '../View/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: Routes.LANGUAGE, page: () => const LanguageSelection()),
    GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
    GetPage(name: Routes.REGISTER, page: () => const RegisterScreen()),
    GetPage(name: Routes.FORGET_PASSWORD, page: () => const ForgotPasswordScreen()),
    GetPage(name: Routes.VERIFY_OTP, page: () => const VerifyOtp()),
    GetPage(name: Routes.RESET_PASSWORD, page: () => const ResetPassword()),
    GetPage(name: Routes.CHANGE_PASSWORD, page: () => const ChangePassword()),
    GetPage(name: Routes.EDIT_PROFILE, page: () => const EditProfile()),
    GetPage(
      name: Routes.HOME,
      page: () => const player.NavigatorScreen(route: Routes.HOME),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const player.NavigatorScreen(route: Routes.NOTIFICATIONS),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const player.NavigatorScreen(route: Routes.PROFILE),
    ),
    GetPage(
      name: Routes.GAMES,
      page: () {
        final UserViewModel userViewModel = Get.put(UserViewModel(), permanent: true);
        int? id = int.tryParse(Get.parameters['id'] ?? '');
        if (id == null) {
          return const player.NavigatorScreen(route: Routes.HOME);
        } else {
          return const GameDetails();
        }
      },
    ),
    GetPage(
      name: Routes.WALLET,
      page: () {

        return const Wallet();
        /*int? id = int.tryParse(Get.parameters['id'] ?? '');
        if (id == null) {
          return const Payments();
        } else {
          return const PaymentDetails();
        }*/
      },
    ),
    GetPage(
      name: Routes.TRANSACTIONS,
      page: () {

        int? id = int.tryParse(Get.parameters['id'] ?? '');
        if (id == null) {
          return const Transactions();
        } else {
          return const TransactionDetails();
        }
      },
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicy(),
    ),
    GetPage(
      name: Routes.CREATE_GAME,
      page: () => const CreateGameScreen(),
    ),
    GetPage(
      name: Routes.HELP_CENTER,
      page: () => const HelpCenter(),
    ),
  ];
}