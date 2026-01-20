class CardModel {
  int? id;
  int? userId;
  int? number;
  String? holderName;
  DateTime? expirationDate;
  String? cvv;
  DateTime? createdAt;
  DateTime? updatedAt;

  CardModel({
    this.id,
    this.userId,
    this.number,
    this.holderName,
    this.expirationDate,
    this.cvv,
    this.createdAt,
    this.updatedAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      userId: json['user_id'],
      number: json['number'],
      holderName: json['holder_name'],
      expirationDate: json['expiration_date'] != null ? DateTime.parse(json['expiration_date']) : null,
      cvv: json['cvv'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'number': number,
      'holder_name': holderName,
      'expiration_date': expirationDate?.toIso8601String(),
      'cvv': cvv,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}