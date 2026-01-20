import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/auth_view_model.dart';
import '../ViewModel/game_view_model.dart';
import '../ViewModel/notification_view_model.dart';
import '../ViewModel/settings_view_model.dart';
import '../ViewModel/user_view_model.dart';

class AppConst {

  static Color primaryColor = const Color(0xff4CAF50);
  static Color secondaryColor = const Color(0xff0084FF);

  static Color lightTextColor = const Color(0xff000000);
  static Color darkTextColor = const Color(0xffFFFFFF);
  static Color lightBackgroundColor = const Color(0xffFFFFFF);
  static Color darkBackgroundColor = const Color(0xff1B1B1B);

// App Bar colors
  static Color lightAppBarColor = const Color(0xffFAFAFA);
  static Color darkAppBarColor = const Color(0xff242424);

// Text Colors
  static Color lightTextSecondaryColor = const Color(0xFF757575);
  static Color darkTextSecondaryColor = const Color(0xFFB0B0B0);
  static Color lightTextDisabledColor = const Color(0xFFBDBDBD);
  static Color darkTextDisabledColor = const Color(0xFF666666);

// Status Colors
  static Color successColor = const Color(0xFF4CAF50);
  static Color errorColor = const Color(0xFFE53935);
  static Color warningColor = const Color(0xFFFFB300);
  static Color infoColor = secondaryColor;

// Card/Surface Colors
  static Color lightSurfaceColor = const Color(0xFFFFFFFF);
  static Color darkSurfaceColor = const Color(0xFF242424);
  static Color lightCardColor = const Color(0xFFFAFAFA);
  static Color darkCardColor = const Color(0xFF2C2C2C);

// Border Colors
  static Color lightBorderColor = const Color(0xFFE0E0E0);
  static Color darkBorderColor = const Color(0xFF404040);

// Input Field Colors
  static Color lightInputFillColor = const Color(0xFFF5F5F5);
  static Color darkInputFillColor = const Color(0xFF333333);
  static Color lightInputBorderColor = const Color(0xFFE0E0E0);
  static Color darkInputBorderColor = const Color(0xFF505050);

// Divider Colors
  static Color lightDividerColor = const Color(0xFFE0E0E0);
  static Color darkDividerColor = const Color(0xFF404040);

// Shadow Colors
  static Color lightShadowColor = const Color(0x1F000000);
  static Color darkShadowColor = const Color(0x1F000000);

// Overlay Colors
  static Color lightOverlayColor = const Color(0x0A000000);
  static Color darkOverlayColor = const Color(0x0AFFFFFF);

// Shimmer Effect Colors
  static Color lightShimmerBaseColor = const Color(0xFFE0E0E0);
  static Color lightShimmerHighlightColor = const Color(0xFFF5F5F5);
  static Color darkShimmerBaseColor = const Color(0xFF3D3D3D);
  static Color darkShimmerHighlightColor = const Color(0xFF525252);

// Shadow Styles
  static List<BoxShadow> lightThemeShadow = [
    BoxShadow(
      color: lightShadowColor,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> darkThemeShadow = [
    BoxShadow(
      color: darkShadowColor,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

// Gradient Colors
  static LinearGradient primaryGradient = LinearGradient(
    colors: [
      primaryColor,
      const Color(0xFFD81B60), // Lighter shade of primary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient secondaryGradient = LinearGradient(
    colors: [
      secondaryColor,
      const Color(0xFFFF7043), // Lighter shade of secondary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

// Helper method to get theme-aware colors
  static Color getThemeAwareColor(BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.light ? lightColor : darkColor;
  }

// Helper method to get theme-aware shadows
  static List<BoxShadow> getThemeAwareShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightThemeShadow
        : darkThemeShadow;
  }


  static MaterialColor primarySwatch = const MaterialColor(
    0xFF4CAF50,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(0xFF4CAF50),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );



  static Future<void> restartViewModel() async{
    // Delete all ViewModels
    await Get.delete<AuthViewModel>(force: true);
    await Get.delete<UserViewModel>(force: true);
    await Get.delete<SettingsViewModel>(force: true);
    await Get.delete<NotificationViewModel>(force: true);
    await Get.delete<GameViewModel>(force: true);
    // Re-initialize all ViewModels with permanent: true
    Get.put(SettingsViewModel(), permanent: true);
    Get.put(AuthViewModel(), permanent: true);
    Get.put(UserViewModel(), permanent: true);
    Get.put(NotificationViewModel(), permanent: true);
    Get.put(GameViewModel(), permanent: true);


  }



  static late SharedPreferences prefs;
  //http://192.168.179.63/qplay/public/api
  //static String endPoint = 'https://www.q-play.in/api';
  static String endPoint = 'https://www.q-play.in/api';


}
