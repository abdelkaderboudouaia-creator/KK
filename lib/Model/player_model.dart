

// lib/data/models/player_model.dart

/// Represents a player profile that is linked to a [UserModel].
///
/// When a user registers with the `player` role the backend creates a
/// corresponding [PlayerModel] row.  The object is returned nested inside
/// [UserModel.player] and is also referenced by [PlayerTeamModel].
class PlayerModel {
  final int id;
  final int? userId;
  final String createdAt;
  final String updatedAt;

  PlayerModel({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}