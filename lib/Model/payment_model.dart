
import 'package:qplay/Model/game_model.dart';
import 'package:qplay/Model/team_model.dart';
import 'package:qplay/Model/user_model.dart';

class PaymentModel {
  final int? id;
  final String? skipCashPaymentId;
  final int? userId;
  final int? gameId;
  final int? teamId;
  final String? status;
  final String? transactionId;
  final double? amount;
  final String? description;
  final String? payUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relations
  final UserModel? user;
  final GameModel? game;
  final TeamModel? team;

  PaymentModel({
    this.id,
    this.skipCashPaymentId,
    this.userId,
    this.gameId,
    this.teamId,
    this.status,
    this.transactionId,
    this.amount,
    this.description,
    this.payUrl,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.game,
    this.team,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      skipCashPaymentId: json['skip_cash_payment_id'],
      userId: json['user_id'],
      gameId: json['game_id'],
      teamId: json['team_id'],
      status: json['status'],
      transactionId: json['transaction_id'],
      amount: json['amount'] != null
          ? (json['amount'] is String
          ? double.tryParse(json['amount'])
          : (json['amount'] as num).toDouble())
          : null,
      description: json['description'],
      payUrl: json['pay_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,

      // Relations
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      game: json['game'] != null ? GameModel.fromJson(json['game']) : null,
      team: json['team'] != null ? TeamModel.fromJson(json['team']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skip_cash_payment_id': skipCashPaymentId,
      'user_id': userId,
      'game_id': gameId,
      'team_id': teamId,
      'status': status,
      'transaction_id': transactionId,
      'amount': amount,
      'description': description,
      'pay_url': payUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
      'game': game?.toJson(),
      'team': team?.toJson(),
    };
  }
}
