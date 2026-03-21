

import 'package:qplay/Model/notification_model.dart';
import 'package:qplay/Model/user_model.dart';

/// Pivot model that tracks whether a specific [UserModel] has read a given
/// [NotificationModel].
///
/// The backend creates one [UserNotificationModel] row per
/// (user, notification) pair. [isRead] and [readAt] are updated when the
/// user taps the notification or calls "mark all as read".
class UserNotificationModel {
  final int id;
  final int? userId;
  final int? notificationId;
  final bool isRead;
  final String? readAt;
  final String createdAt;
  final String updatedAt;
  final UserModel? user;
  final NotificationModel? notification;

  UserNotificationModel({
    required this.id,
    this.userId,
    this.notificationId,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.notification,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) {
    return UserNotificationModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      notificationId: json['notification_id'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      notification: json['notification'] != null ? NotificationModel.fromJson(json['notification']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'notification_id': notificationId,
      'is_read': isRead,
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'notification': notification?.toJson(),
    };
  }

  DateTime? get readDate => readAt != null ? DateTime.parse(readAt!) : null;
}