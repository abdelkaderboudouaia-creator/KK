


import 'package:qplay/Model/user_model.dart';
import 'package:qplay/Model/wallet_transaction_model.dart';

/// Represents the digital wallet belonging to a [UserModel].
///
/// Each user has exactly one wallet.  The wallet's current [balance] is
/// displayed on the **Wallet** screen, and [transactions] holds the full
/// history of [WalletTransactionModel] entries.
///
/// Helper getters:
/// * [incomeTransactions] / [expenseTransactions] – filtered sublists.
/// * [totalIncome] / [totalExpenses]             – aggregated amounts.
class WalletModel {
  final int id;
  final int? userId;
  final double balance;
  final String createdAt;
  final String updatedAt;

  // Relations
  final UserModel? user;
  final List<WalletTransactionModel> transactions;

  WalletModel({
    required this.id,
    this.userId,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      balance: (double.tryParse(json['balance']) ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
          .map((transaction) => WalletTransactionModel.fromJson(transaction))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (user != null) 'user': user!.toJson(),
      if (transactions != null) 'transactions': transactions!.map((t) => t.toJson()).toList(),
    };
  }

  // Helper methods
  String get formattedBalance => '\${balance.toStringAsFixed(2)}';

  int get transactionCount => transactions?.length ?? 0;

  List<WalletTransactionModel> get incomeTransactions =>
      transactions?.where((t) => t.type == 'in').toList() ?? [];

  List<WalletTransactionModel> get expenseTransactions =>
      transactions?.where((t) => t.type == 'out').toList() ?? [];

  double get totalIncome =>
      incomeTransactions.fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses =>
      expenseTransactions.fold(0.0, (sum, t) => sum + t.amount);
}