
// lib/data/models/user_model.dart


import 'package:qplay/Model/admin_model.dart';
import 'package:qplay/Model/player_model.dart';

class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String? birthday;
  final String role;
  final String countryCode;
  final String photo;
  final String phone;
  final String language;
  final bool isVerified;
  final bool isBlocked;
  final String? pushToken;
  final String email;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final AdminModel? admin;
  final PlayerModel? player;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.birthday,
    required this.role,
    required this.countryCode,
    required this.photo,
    required this.phone,
    required this.language,
    required this.isVerified,
    required this.isBlocked,
    this.pushToken,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.admin,
    this.player,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      birthday: json['birthday'],
      role: json['role'] ?? 'player',
      countryCode: json['country_code'] ?? '',
      photo: json['photo'] ?? '',
      phone: json['phone'] ?? '',
      language: json['language'] ?? 'ar',
      isVerified: (json['is_verified'] ?? 0) == 1,
      isBlocked: (json['is_blocked'] ?? 0) == 1,
      pushToken: json['push_token'],
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      admin: json['admin'] != null ? AdminModel.fromJson(json['admin']) : null,
      player: json['player'] != null ? PlayerModel.fromJson(json['player']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday,
      'role': role,
      'country_code': countryCode,
      'photo': photo,
      'phone': phone,
      'language': language,
      'is_verified': isVerified,
      'is_blocked': isBlocked,
      'push_token': pushToken,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'admin': admin?.toJson(),
      'player': player?.toJson(),
    };
  }

  String get fullName => '$firstName $lastName';
  bool get isAdmin => role == 'admin';
  bool get isPlayer => role == 'player';

  UserModel copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? birthday,
    String? role,
    String? countryCode,
    String? photo,
    String? phone,
    String? language,
    bool? isVerified,
    bool? isBlocked,
    String? pushToken,
    String? email,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    AdminModel? admin,
    PlayerModel? player,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      role: role ?? this.role,
      countryCode: countryCode ?? this.countryCode,
      photo: photo ?? this.photo,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      isVerified: isVerified ?? this.isVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      pushToken: pushToken ?? this.pushToken,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      admin: admin ?? this.admin,
      player: player ?? this.player,
    );
  }
}