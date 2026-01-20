import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Helper/app_const.dart';
import '../../ViewModel/settings_view_model.dart';
//'Are you sure ? '
void showCustomDialog({required String text,required Function()? onPressed, Widget? widget}) {
  SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
  Get.dialog(Center(
    child: LayoutBuilder(
      builder: (context,boxConstraints) {
        return Container(
          width: boxConstraints.maxWidth > 330 ? 300 : boxConstraints.maxWidth - 30,
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? AppConst.darkSurfaceColor : AppConst.lightSurfaceColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 110.0, maxWidth: boxConstraints.maxWidth > 330 ? 300 : boxConstraints.maxWidth - 30,),
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
                          text.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17.0,
                              decorationThickness: 0,
                              decoration: TextDecoration.none,
                              color: Get.isDarkMode
                                  ? AppConst.darkTextColor : AppConst.lightTextColor,
                              fontFamily: 'BalooBhaijaan2',
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,
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
                              SizedBox(
                                width: 120,
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    ),
  ));
}
