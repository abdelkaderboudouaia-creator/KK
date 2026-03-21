import 'package:qplay/Model/game_model.dart';
import 'package:qplay/Model/team_model.dart';
import 'package:qplay/Model/wallet_model.dart';

/// Represents a single credit or debit entry in a [WalletModel].
///
/// [type] is either:
/// * `'in'`  – money was added to the wallet (e.g. a top-up).
/// * `'out'` – money was deducted from the wallet (e.g. joining a game).
///
/// Optional relations [game] and [team] give context about which match the
/// transaction is linked to.  [formattedAmount] produces a human-readable
/// string such as `+$25.00` or `-$25.00`.
class WalletTransactionModel {
  final int id;
  final int? walletId;
  final int? gameId;
  final int? teamId;
  final String transactionId;
  final double amount;
  final String? description;
  final String type; // 'in' or 'out'
  final String createdAt;
  final String updatedAt;

  // Relations
  final WalletModel? wallet;
  final GameModel? game;
  final TeamModel? team;

  WalletTransactionModel({
    required this.id,
    this.walletId,
    this.gameId,
    this.teamId,
    required this.transactionId,
    required this.amount,
    this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.wallet,
    this.game,
    this.team,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] ?? 0,
      walletId: json['wallet_id'],
      gameId: json['game_id'],
      teamId: json['team_id'],
      transactionId: json['transaction_id'] ?? '',
      amount: (double.tryParse(json['amount']) ?? 0).toDouble(),
      description: json['description'],
      type: json['type'] ?? 'out',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      wallet: json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null,
      game: json['game'] != null ? GameModel.fromJson(json['game']) : null,
      team: json['team'] != null ? TeamModel.fromJson(json['team']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'game_id': gameId,
      'team_id': teamId,
      'transaction_id': transactionId,
      'amount': amount,
      'description': description,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (wallet != null) 'wallet': wallet!.toJson(),
      if (game != null) 'game': game!.toJson(),
      if (team != null) 'team': team!.toJson(),
    };
  }

  // Helper methods
  bool get isIncome => type == 'in';
  bool get isExpense => type == 'out';

  String get formattedAmount {
    final prefix = isIncome ? '+' : '-';
    return '$prefix\$${amount.toStringAsFixed(2)}';
  }
}