import 'package:flutter/material.dart';

import 'app_const.dart';


class AppTheme {

  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: AppConst.primarySwatch,
    primaryColor: AppConst.primaryColor,
    scaffoldBackgroundColor: AppConst.lightBackgroundColor,
    fontFamily: 'BalooBhaijaan2',

    appBarTheme: AppBarTheme(
      backgroundColor: AppConst.lightAppBarColor,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppConst.lightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'BalooBhaijaan2',
      ),
    ),

    cardTheme: CardTheme(
      color: AppConst.lightSurfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: AppConst.lightShadowColor,
    ),

    dividerColor: AppConst.lightDividerColor,


    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppConst.lightTextColor),
      bodyMedium: TextStyle(color: AppConst.lightTextColor),
      labelSmall: TextStyle(color: AppConst.lightTextColor),
      headlineLarge: TextStyle(color: AppConst.lightTextColor),
      headlineMedium: TextStyle(color: AppConst.lightTextColor),
      headlineSmall: TextStyle(color: AppConst.lightTextColor),
      titleLarge: TextStyle(color: AppConst.lightTextColor),
      titleMedium: TextStyle(color: AppConst.lightTextColor),
      titleSmall: TextStyle(color: AppConst.lightTextColor),
      bodySmall: TextStyle(color: AppConst.lightTextColor),
      labelLarge: TextStyle(color: AppConst.lightTextColor),
      labelMedium: TextStyle(color: AppConst.lightTextColor),
      displayLarge: TextStyle(color: AppConst.lightTextColor),
      displayMedium: TextStyle(color: AppConst.lightTextColor),
      displaySmall: TextStyle(color: AppConst.lightTextColor),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConst.lightInputFillColor,
      hintStyle: const TextStyle(color: Colors.grey,),
      errorStyle: const TextStyle(fontWeight: FontWeight.w500,),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
    ),

    iconTheme: IconThemeData(
      color: AppConst.lightTextSecondaryColor,
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: AppConst.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textStyle: WidgetStateProperty.all(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontFamily: 'BalooBhaijaan2'),),
      ),
    ),

    shadowColor: AppConst.lightShadowColor,
    splashColor: AppConst.lightOverlayColor,
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: AppConst.primarySwatch,
    primaryColor: AppConst.primaryColor,
    scaffoldBackgroundColor: AppConst.darkBackgroundColor,
    fontFamily: 'BalooBhaijaan2',

    appBarTheme: AppBarTheme(
      backgroundColor: AppConst.darkAppBarColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppConst.darkTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'BalooBhaijaan2',
      ),
    ),

    cardTheme: CardTheme(
      color: AppConst.darkSurfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: AppConst.darkShadowColor,
    ),

    dividerColor: AppConst.darkDividerColor,



    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppConst.darkTextColor),
      bodyMedium: TextStyle(color: AppConst.darkTextColor),
      labelSmall: TextStyle(color: AppConst.darkTextColor),
      headlineLarge: TextStyle(color: AppConst.darkTextColor),
      headlineMedium: TextStyle(color: AppConst.darkTextColor),
      headlineSmall: TextStyle(color: AppConst.darkTextColor),
      titleLarge: TextStyle(color: AppConst.darkTextColor),
      titleMedium: TextStyle(color: AppConst.darkTextColor),
      titleSmall: TextStyle(color: AppConst.darkTextColor),
      bodySmall: TextStyle(color: AppConst.darkTextColor),
      labelLarge: TextStyle(color: AppConst.darkTextColor),
      labelMedium: TextStyle(color: AppConst.darkTextColor),
      displayLarge: TextStyle(color: AppConst.darkTextColor),
      displayMedium: TextStyle(color: AppConst.darkTextColor),
      displaySmall: TextStyle(color: AppConst.darkTextColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConst.darkInputFillColor,
      hintStyle: const TextStyle(color: Colors.grey,),
      errorStyle: const TextStyle(fontWeight: FontWeight.w500,),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            style: BorderStyle.none,
          )
      ),
    ),

    iconTheme: IconThemeData(
      color: AppConst.darkTextSecondaryColor,
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: AppConst.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textStyle: WidgetStateProperty.all(const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 16,fontFamily: 'BalooBhaijaan2'),),
      ),
    ),

    shadowColor: AppConst.darkShadowColor,
    splashColor: AppConst.darkOverlayColor,
  );
}

