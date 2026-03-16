import '/Helper/app_const.dart';

import '/ViewModel/settings_view_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

/// Simple enum-like class that defines the three message types used by
/// [showCustomMessageDialog]:
/// * [Type.error]   – displayed with a red badge icon.
/// * [Type.warning] – displayed with a yellow badge icon.
/// * [Type.success] – displayed with a green badge icon.
class Type {
  static String error = 'Error';
  static String warning = 'Warning';
  static String success = 'Success';
}

/// Shows a modal feedback dialog using [Get.dialog].
///
/// [text] is the message body.  [type] must be one of the constants from
/// [Type] (`'Error'`, `'Warning'`, `'Success'`).  An optional
/// [buttonText] label overrides the default "Close" text, and [onPressed]
/// lets callers perform an action when the button is tapped.
/// [barrierDismissible] controls whether tapping outside the dialog closes it.
void showCustomMessageDialog(String text, String type,{String buttonText = 'Close',void Function()? onPressed,bool barrierDismissible = true}) {
  SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
  Get.dialog(

    LayoutBuilder(
      builder: (context,boxConstraints) {
        return Center(
          child: badges.Badge(
            badgeAnimation: const badges.BadgeAnimation.rotation(),
            badgeStyle: badges.BadgeStyle(
                badgeColor: Get.isDarkMode
                    ? AppConst.darkSurfaceColor : AppConst.lightSurfaceColor,
            ),
            position: badges.BadgePosition.topStart(
                start: ((boxConstraints.maxWidth < 600 ? boxConstraints.maxWidth  * 0.7 : 350)  - 60) / 2, top: -45),
            badgeContent: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset('assets/images/${type.toLowerCase()}.png'),
            ),
            child: Container(
              width: boxConstraints.maxWidth < 600 ? boxConstraints.maxWidth  * 0.7 : 350,
              decoration: BoxDecoration(
                color:  Get.isDarkMode
                    ? AppConst.darkSurfaceColor : AppConst.lightSurfaceColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 150.0,
                          maxWidth: boxConstraints.maxWidth < 600 ? boxConstraints.maxWidth  * 0.7 : 350),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              type.tr,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  decorationThickness: 0,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'BalooBhaijaan2',
                                  color: Get.isDarkMode
                                      ? AppConst.darkTextColor : AppConst.lightTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decorationThickness: 0,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'BalooBhaijaan2',
                                  fontSize: 16,
                                  color: Get.isDarkMode
                                      ? AppConst.darkTextColor : AppConst.lightTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConst.primaryColor,
                                  )
                                ],
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(AppConst.primaryColor),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100))),
                                ),
                                onPressed: onPressed ?? () {
                                  Get.back();
                                },
                                child: Text(
                                  buttonText.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    ),
    barrierDismissible: barrierDismissible
  );
}
