import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/app_const.dart';

import 'package:intl/intl.dart' as intl;
import 'package:qplay/Helper/app_routes.dart';
import 'package:qplay/Model/wallet_transaction_model.dart';

/// A list-tile card for a single [WalletTransactionModel].
///
/// Displays the transaction icon (credit ↑ / debit ↓), formatted amount,
/// description, and date.  Tapping navigates to [Routes.TRANSACTIONS] with
/// the transaction `id` as a query parameter.
class TransactionCard extends StatelessWidget {
  final WalletTransactionModel transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppConst.darkCardColor : AppConst.lightCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Transaction Info
                _buildTransactionInfo(),

                const SizedBox(height: 16),

                // Game/Team Info (if available)
                if (transaction.game != null || transaction.team != null)
                  _buildRelatedInfo(),
              ],
            ),
          ),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          // Transaction Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getTypeColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getTypeText(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const Spacer(),

          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              _formatAmount(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _getTypeColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Column(
      children: [
        _buildInfoRow(
          icon: Icons.receipt_long_outlined,
          label: 'Transaction ID',
          value: transaction.transactionId,
        ),

        if (transaction.description != null && transaction.description!.isNotEmpty)
          _buildInfoRow(
            icon: Icons.description_outlined,
            label: 'Description',
            value: transaction.description!,
          ),

        _buildInfoRow(
          icon: Icons.access_time_outlined,
          label: 'Date & Time',
          value: _formatDateTime(transaction.createdAt),
        ),

      ],
    );
  }

  Widget _buildRelatedInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppConst.darkSurfaceColor.withOpacity(0.5)
            : AppConst.lightSurfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Information'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Get.isDarkMode
                  ? AppConst.darkTextSecondaryColor
                  : AppConst.lightTextSecondaryColor,
            ),
          ),

          const SizedBox(height: 12),

          if (transaction.game != null) ...[
            Row(
              children: [
                Icon(
                  Icons.sports_esports_outlined,
                  size: 18,
                  color: AppConst.primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${'Match'.tr} : ${transaction.game!.gameType.tr}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          if (transaction.team != null) ...[
            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 18,
                  color: AppConst.secondaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${'Team'.tr} : ${transaction.team!.name.tr}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Get.isDarkMode
                ? AppConst.darkTextSecondaryColor
                : AppConst.lightTextSecondaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.isDarkMode
                        ? AppConst.darkTextSecondaryColor
                        : AppConst.lightTextSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('${Routes.TRANSACTIONS}?id=${transaction.id}');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Get.isDarkMode
                  ? AppConst.darkBorderColor
                  : AppConst.lightBorderColor,
            ),
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Details'.tr,
              style: TextStyle(
                color: AppConst.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: AppConst.primaryColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor() {
    return transaction.isIncome ? AppConst.successColor : AppConst.errorColor;
  }

  String _getTypeText() {
    return transaction.isIncome ? 'INCOME'.tr : 'EXPENSE'.tr;
  }

  String _formatAmount() {
    final prefix = transaction.isIncome ? '+' : '-';
    return '$prefix${transaction.amount.toStringAsFixed(2)} ${'QAR'.tr}';
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return intl.DateFormat('MMM dd, yyyy • HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}

class TransactionPlaceholder extends StatelessWidget {
  const TransactionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppConst.darkCardColor : AppConst.lightCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Placeholder
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getShimmerColor(),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                _buildShimmerBox(80, 24),
                const Spacer(),
                _buildShimmerBox(120, 16),
              ],
            ),
          ),

          // Content Placeholder
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Info rows
                ...List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      _buildShimmerBox(18, 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShimmerBox(80, 12),
                            const SizedBox(height: 4),
                            _buildShimmerBox(150, 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),

          // Footer Placeholder
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Get.isDarkMode
                      ? AppConst.darkBorderColor
                      : AppConst.lightBorderColor,
                ),
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Center(
              child: _buildShimmerBox(120, 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _getShimmerColor(),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Color _getShimmerColor() {
    return Get.isDarkMode
        ? AppConst.darkSurfaceColor.withOpacity(0.3)
        : AppConst.lightSurfaceColor.withOpacity(0.8);
  }
}