import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Helper/app_const.dart';
import '../../../ViewModel/settings_view_model.dart';

//'Are you sure ? '


Future<void> showConfirmationDialog({required String title,required String text,required Function() onPressed}) async {

  SettingsViewModel settingsViewModel = Get.find<SettingsViewModel>();

  Get.dialog(
    AlertDialog(
      backgroundColor: Get.isDarkMode ? AppConst.darkSurfaceColor : AppConst.lightSurfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title.tr,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        text.tr,
        style: TextStyle(
          fontWeight: FontWeight.w500
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel'.tr,
            style: TextStyle(
              color: Get.isDarkMode ? AppConst.darkTextSecondaryColor : AppConst.lightTextSecondaryColor,
            ),
          ),
        ),
        // Delete Button
        ElevatedButton(
          onPressed: () {
            Get.back();
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Confirm'.tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
void showCustomDialog({required String text,required Function()? onPressed, Widget? widget}) {
  Get.dialog(Center(
    child: Container(
      width: MediaQuery.of(Get.context!).size.width * 0.7,
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppConst.darkBackgroundColor
            : AppConst.lightBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 150.0, maxWidth: MediaQuery.of(Get.context!).size.width * 0.9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    widget != null
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              widget
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0,
                          decorationThickness: 0,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                            Expanded(
                              child: ElevatedButton(

                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConst.primaryColor,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text('Cancel'.tr,style: const TextStyle(color: Colors.white),),
                              ),
                            ),

                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: onPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConst.primaryColor,
                                  shape: const StadiumBorder(),
                                ),
                                child: Text('Yes'.tr,style: const TextStyle(color: Colors.white),),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  ));
}
