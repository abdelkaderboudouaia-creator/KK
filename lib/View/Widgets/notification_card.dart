import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Model/notification_model.dart';
import 'package:qplay/View/Widgets/custom_profile_pic.dart';
import 'package:qplay/ViewModel/notification_view_model.dart';

import '../../Helper/app_const.dart';
import '../../Helper/functions.dart';


class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final lang = Get.locale?.languageCode ?? "en";

    // Extract localized payload (safe lookup)
    final localizedPayload = (notification.payload[lang] as Map?) ?? {};
    final displayTitle = localizedPayload['title'] ?? notification.title;
    final displayBody = localizedPayload['body'] ?? notification.body;
    final route = ((notification.payload as Map?) ?? {})['route'];
    return GestureDetector(
      onTap: (){
        final controller = Get.find<NotificationViewModel>();
        controller.notificationId = notification.id;
        Get.find<NotificationViewModel>().readNotification();
        if(route != null){
          Get.toNamed(route);
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            width: 1,
            color: !notification.isRead
                ? AppConst.primaryColor
                : Colors.transparent,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              CustomProfilePic(
                url: notification.user?.photo ?? 'Unknown',
                size: 40,
                name: notification.user?.fullName ?? 'Unknown',
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width - 30 - 68,
                    child: Text(
                      '${notification.user?.fullName} - $displayTitle - ${showTime(DateTime.parse(notification.createdAt))}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: Get.width - 35 - 64,
                    child: Text(
                      displayBody,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
