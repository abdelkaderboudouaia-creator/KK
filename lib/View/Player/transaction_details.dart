import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/app_const.dart';
import 'package:qplay/ViewModel/payment_view_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qplay/Model/wallet_transaction_model.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final PaymentViewModel paymentViewModel = Get.put(PaymentViewModel());

  late WalletTransactionModel transaction;
  bool loading = true;
  late bool isExist;

  @override
  void initState() {
    super.initState();
    paymentViewModel.getTransaction(int.tryParse(Get.parameters['id'] ?? '') ?? 0).then((e) {
      if (e != null) {
        isExist = true;
        transaction = e;
      } else {
        isExist = false;
      }
      setState(() {
        loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppConst.darkBackgroundColor
          : AppConst.lightBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (loading) {
              return const TransactionDetailsPlaceholder();
            } else if (isExist) {
              return CustomScrollView(
                slivers: [


                  // Content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section
                        _buildHeroSection(),

                        // Transaction Information
                        _buildTransactionInformation(),

                        // Transaction Details
                        _buildTransactionDetails(),

                        // Related Game (if available)
                        if (transaction.game != null) _buildRelatedGame(),

                        // Related Team (if available)
                        if (transaction.team != null) _buildRelatedTeam(),

                        // Wallet Information
                        _buildWalletInformation(),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return _buildNotFoundState();
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          const SizedBox(height: 16),

          // Title
          Text(
            'Transaction Details'.tr,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Transaction ID with copy button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  transaction.transactionId,
                  style: TextStyle(
                    fontSize: 16,
                    color: Get.isDarkMode ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: transaction.transactionId));
                  Get.snackbar(
                    'Copied'.tr,
                    'Transaction ID copied to clipboard'.tr,
                    colorText: Colors.white,
                    backgroundColor: Colors.green,
                  );
                },
                icon: Icon(
                  Icons.copy_sharp,
                  color: AppConst.primaryColor,
                  size: 16,
                ),
              )
            ],
          ),

          const SizedBox(height: 24),

          // Amount
          Row(
            children: [
              Text(
                _formatAmount(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _getTypeColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInformation() {
    return _buildSection(
      title: 'Transaction Information',
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.confirmation_number_outlined,
            label: 'Transaction ID',
            value: transaction.transactionId,
          ),
          _buildDetailRow(
            icon: Icons.swap_horiz_outlined,
            label: 'Type',
            value: _getTypeText(),
          ),
          _buildDetailRow(
            icon: Icons.attach_money_outlined,
            label: 'Amount',
            value: _formatAmount(),
          ),
          if (transaction.description != null && transaction.description!.isNotEmpty)
            _buildDetailRow(
              icon: Icons.description_outlined,
              label: 'Description',
              value: transaction.description!,
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return _buildSection(
      title: 'Transaction Details',
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.access_time_outlined,
            label: 'Created At',
            value: _formatDateTime(transaction.createdAt),
          ),
          _buildDetailRow(
            icon: Icons.update_outlined,
            label: 'Last Updated',
            value: _formatDateTime(transaction.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedGame() {
    return _buildSection(
      title: 'Related Match',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppConst.primaryColor.withOpacity(0.1)
              : AppConst.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_esports_outlined,
                  color: AppConst.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    transaction.game!.gameType.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${'Type'.tr} : ${transaction.game!.gameType.tr}',
              style: TextStyle(
                fontSize: 14,
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${'Date'.tr} : ${_formatDateTime(transaction.game!.matchDate)}',
              style: TextStyle(
                fontSize: 14,
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedTeam() {
    return _buildSection(
      title: 'Related Team',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppConst.primaryColor.withOpacity(0.1)
              : AppConst.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.group_outlined,
              color: AppConst.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                transaction.team!.name.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletInformation() {
    return _buildSection(
      title: 'Wallet Information',
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet ID',
            value: transaction.walletId?.toString() ?? 'N/A',
          ),
          if (transaction.wallet != null) ...[
            _buildDetailRow(
              icon: Icons.person_outlined,
              label: 'User ID',
              value: transaction.wallet!.userId?.toString() ?? 'N/A',
            ),
            _buildDetailRow(
              icon: Icons.account_balance_outlined,
              label: 'Current Balance',
              value: '${transaction.wallet!.balance.toStringAsFixed(2)} ${'QAR'.tr}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Get.isDarkMode ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label.tr,
              style: TextStyle(
                fontSize: 15,
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Get.isDarkMode
                  ? AppConst.darkTextSecondaryColor.withOpacity(0.5)
                  : AppConst.lightTextSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Transaction Not Found'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The transaction has been deleted or does not exist'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode
                    ? AppConst.darkTextSecondaryColor
                    : AppConst.lightTextSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Go Back'.tr),
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
      if(Get.locale!.languageCode == 'ar'){
        final dateTime = DateTime.parse(dateTimeString);
        final formatter = intl.DateFormat('MMM dd, yyyy • HH:mm');
        String formattedDate = formatter.format(dateTime);

        final weekdayFormatter = intl.DateFormat('EEEE');
        String englishWeekday = weekdayFormatter.format(dateTime);

        String arabicWeekday = englishWeekday.tr;

        return '$arabicWeekday, $formattedDate';
      }
      else{
        final dateTime = DateTime.parse(dateTimeString);
        return intl.DateFormat('EEEE, MMM dd, yyyy • HH:mm').format(dateTime);
      }

    } catch (e) {
      return dateTimeString;
    }
  }
}

class TransactionDetailsPlaceholder extends StatelessWidget {
  const TransactionDetailsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar Placeholder
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getShimmerColor(),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Content Placeholder
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section Placeholder
              Container(
                margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(80, 32),
                    const SizedBox(height: 16),
                    _buildShimmerBox(250, 32),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildShimmerBox(200, 16)),
                        _buildShimmerBox(16, 16),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildShimmerBox(150, 28),
                  ],
                ),
              ),

              // Sections Placeholder
              ...List.generate(
                4,
                    (index) => Container(
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(150, 20),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _getShimmerColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
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
