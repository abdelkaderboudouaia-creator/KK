import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/View/Widgets/notification_card.dart';
import 'package:qplay/ViewModel/user_view_model.dart';

import '../../../Helper/app_const.dart';
import '../../../ViewModel/notification_view_model.dart';
import '../../../ViewModel/settings_view_model.dart';

/// Notifications tab – shows the real-time notification feed.
///
/// Observes [NotificationViewModel.notifications] (a reactive list) and
/// renders each item with [NotificationCard].  An unread badge count is
/// displayed on the bottom-nav icon via [NotificationViewModel.allRead].
/// A "Mark all as read" action is available in the app bar.
class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationViewModel notificationViewModel =
      Get.find<NotificationViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          centerTitle: true,
          title: Text(
            'Notifications'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Get.find<UserViewModel>().isLoggedIn ? Obx(
          () => notificationViewModel.notifications.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () async {
                            await notificationViewModel.readAllNotification();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: AppConst.primaryColor),
                          child: Text(
                            'Mark all as read'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: notificationViewModel.notifications.length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onTap: () {},
                              child: NotificationCard(
                                notification:
                                    notificationViewModel.notifications[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/notification.png',
                        width: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Notifications Yet'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'When you get notifications, they’ll show up here'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
        ) : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, color: AppConst.secondaryColor, size: 60),
              SizedBox(height: 16),
              SizedBox(height: 8),
              Text(
                "Please sign in to continue".tr,
                style: TextStyle(
                    color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.offAllNamed('/login');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppConst.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Sign In'.tr,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
