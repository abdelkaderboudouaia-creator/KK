import 'dart:convert';

import 'package:qplay/Model/user_model.dart';
import 'package:qplay/Model/user_notification_model.dart';

/// Represents a push notification sent from the backend to one or more users.
///
/// Notifications are received through two channels:
/// 1. **Firebase Cloud Messaging (FCM)** – handled in the
///    `_background` function in `main.dart`.
/// 2. **WebSocket (Pusher)** – streamed via [NotificationApi.connect] and
///    accumulated in [NotificationViewModel.notifications].
///
/// [payload] is a key-value map that may contain a `route` key used to
/// deep-link the user to a specific screen when the notification is tapped.
/// [isRead] reflects whether the currently authenticated user has already
/// read this notification.
class NotificationModel {
  final int id;
  final int? userId;
  final String title;
  final String body;
  final Map<String, dynamic> payload;
  final bool isScheduled;
  final String? scheduledAt;
  final String createdAt;
  final String updatedAt;
  final UserModel? user;
  final List<UserNotificationModel>? userNotifications;
  final bool isRead;

  NotificationModel({
    required this.id,
    this.userId,
    required this.title,
    required this.body,
    required this.payload,
    required this.isScheduled,
    this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
    this.user,
    this.userNotifications,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'];
    Map<String, dynamic> parsedPayload = {};


    if (payload is String && payload.isNotEmpty) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map) {
          parsedPayload = Map<String, dynamic>.from(decoded);
        }
      } catch (e) {
        //
      }
    } else if (payload is Map) {
      parsedPayload = Map<String, dynamic>.from(payload);
    }

    return NotificationModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      payload: parsedPayload,
      isScheduled: json['is_scheduled'] ?? false,
      scheduledAt: json['scheduled_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      userNotifications: json['user_notifications'] != null
          ? (json['user_notifications'] as List)
          .map((un) => UserNotificationModel.fromJson(un))
          .toList()
          : null,
      isRead: (json['is_read'] ?? 0) == 1,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'payload': payload,
      'is_scheduled': isScheduled,
      'scheduled_at': scheduledAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'user_notifications': userNotifications?.map((un) => un.toJson()).toList(),
    };
  }

  DateTime get notificationDate => DateTime.parse(createdAt);
  DateTime? get scheduleDate => scheduledAt != null ? DateTime.parse(scheduledAt!) : null;

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    bool? isScheduled,
    String? scheduledAt,
    String? createdAt,
    String? updatedAt,
    UserModel? user,
    List<UserNotificationModel>? userNotifications,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      isScheduled: isScheduled ?? this.isScheduled,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userNotifications: userNotifications ?? this.userNotifications,
      isRead: isRead ?? this.isRead,
    );
  }
}
