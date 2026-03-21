import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart' as an;
import '../Helper/app_const.dart';
import '../Model/notification_model.dart';
import 'Api/notification_api.dart';
import 'user_view_model.dart';

/// GetX controller responsible for real-time notifications.
///
/// On initialisation ([onInit]) this controller:
/// 1. Opens a WebSocket connection ([connect]) to the Pusher-compatible
///    server via [NotificationApi] and subscribes to the user's private
///    channel `private-notifications.<userId>`.
/// 2. Registers an AwesomeNotifications action listener (alias `an`) so that
///    tapping an OS notification deep-links the user to the correct screen.
///
/// [notifications] is a reactive list of [NotificationModel] objects sorted
/// newest-first.  [allRead] is `true` when every notification has been read.
///
/// Public API:
/// * [getNotification]    – loads existing notifications from the REST API.
/// * [readNotification]   – marks a single notification as read.
/// * [readAllNotification]– marks every notification as read.
/// * [disconnect]         – closes the WebSocket (called on logout).
///
/// [redirectRoute] is a static field used to remember a deep-link route
/// that arrived while no user was logged in, so it can be followed after login.
class NotificationViewModel extends GetxController {

  NotificationApi notificationApi = NotificationApi();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  RxBool allRead = true.obs;

  late Stream notificationStream;

  late int notificationId;

  static String? redirectRoute;





  @override
  void onInit() {
    super.onInit();
    connect();
    an.AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

  }



  Future<void> connect() async{
    notificationStream = notificationApi.connect();
    notificationStream.listen((data){
      NotificationModel notification = NotificationModel.fromJson(data);
      if (!notifications.any((msg) => msg.id == notification.id)) {
        notifications.insert(0,notification);
        notifications.sort((a,b){
          return b.createdAt.compareTo(a.createdAt);
        });
        allRead.value = notifications.every((e) => e.isRead);
      }
    });
    await getNotification();
  }

  void disconnect(){
    notificationApi.disconnect();
  }



  Future<void> getNotification() async{
    var r = await notificationApi.getNotifications();
    if(r.statusCode == 200){
      var json = jsonDecode(r.body);
      for(var map in json){
        NotificationModel notification = NotificationModel.fromJson(map);
        if(!notifications.map((e)=>e.id).toList().contains(notification.id)){
          notifications.add(notification);
        }
      }
      notifications.sort((a,b){
        return b.createdAt.compareTo(a.createdAt);
      });
      allRead.value = notifications.every((e) => e.isRead);
    }

  }

  Future<void> readNotification() async {
    var r = await notificationApi.readNotification(notificationId: notificationId);

    if (r.statusCode == 200) {
      // Update the specific notification
      notifications.value = notifications.map((e) {
        if (e.id == notificationId) {
          return e.copyWith(isRead: true); // ✅ update isRead
        }
        return e;
      }).toList();

      // Check if all are read
      allRead.value = notifications.every((e) => e.isRead);

      // Sort by createdAt descending
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      update();
    }
  }


  Future<void> readAllNotification() async {
    final response = await notificationApi.readAllNotification();
    print(response.body);
    if (response.statusCode == 200) {
      notifications.value = notifications.map((e) {
        return e.copyWith(isRead: true);
      }).toList();

      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    allRead.value = notifications.every((e) => e.isRead);
  }







  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(an.ReceivedAction receivedAction) async {
    final UserViewModel userViewModel = Get.put(UserViewModel(), permanent: true);
    if(userViewModel.user != null){
      if(receivedAction.payload?['route'] != null){
        if(receivedAction.payload!['route']! == Get.currentRoute){
          if((Get.isDialogOpen ?? false)){
            Get.back();
          }
          Get.offAndToNamed(receivedAction.payload!['route']!);
        }
        else{
          Get.toNamed(receivedAction.payload!['route']!);
        }

      }
    }
    else{
      redirectRoute = receivedAction.payload!['route']!;
    }

  }



}


