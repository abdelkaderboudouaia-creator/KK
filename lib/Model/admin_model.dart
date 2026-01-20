class AdminModel {
  int? id;
  int? userId;
  bool? isSuperAdmin;
  DateTime? createdAt;
  DateTime? updatedAt;

  AdminModel({
    this.id,
    this.userId,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      userId: json['user_id'],
      isSuperAdmin: json['is_super_admin'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_super_admin': isSuperAdmin,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}