import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/app_const.dart';
import 'package:qplay/Model/wallet_transaction_model.dart';
import 'package:qplay/ViewModel/payment_view_model.dart';
import 'package:qplay/View/Widgets/transaction_card.dart'; // Import your TransactionCard

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final PaymentViewModel paymentViewModel = Get.put(PaymentViewModel());

  @override
  void initState() {
    super.initState();
    // Load transactions if not already loaded
    if (paymentViewModel.wallet.value == null) {
      paymentViewModel.getTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? AppConst.darkBackgroundColor : AppConst.lightBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppConst.primaryColor,
          ),
        ),
        title: Text(
          'Transactions'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (paymentViewModel.isLoading.value) {
          return _buildLoadingState();
        } else if (paymentViewModel.wallet.value == null) {
          return _buildErrorState();
        } else if (paymentViewModel.wallet.value!.transactions.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildTransactionsList(paymentViewModel.wallet.value!.transactions!);
        }
      }),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Show 5 placeholder cards
      itemBuilder: (context, index) {
        return const TransactionPlaceholder();
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Get.isDarkMode
                  ? AppConst.darkTextSecondaryColor.withOpacity(0.5)
                  : AppConst.lightTextSecondaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Error Loading Wallet'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load wallet data. Please try again.'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode
                    ? AppConst.darkTextSecondaryColor
                    : AppConst.lightTextSecondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                paymentViewModel.getTransactions();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConst.primaryColor,
              ),
              child: Text(
                'Retry'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              'No Transactions Found'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You haven\'t made any transactions yet'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode
                    ? AppConst.darkTextSecondaryColor
                    : AppConst.lightTextSecondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Go back to wallet screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConst.primaryColor,
              ),
              child: Text(
                'Back to Wallet'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<WalletTransactionModel> transactions) {
    return RefreshIndicator(
      color: AppConst.primaryColor,
      onRefresh: () async {
        await paymentViewModel.getTransactions();
      },
      child: Column(
        children: [
          // Summary Header
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppConst.darkCardColor : AppConst.lightCardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Transactions'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Get.isDarkMode
                              ? AppConst.darkTextSecondaryColor
                              : AppConst.lightTextSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${transactions.length}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? AppConst.darkTextColor : AppConst.lightTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Get.isDarkMode
                      ? AppConst.darkBorderColor
                      : AppConst.lightBorderColor,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Balance'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Get.isDarkMode
                              ? AppConst.darkTextSecondaryColor
                              : AppConst.lightTextSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${paymentViewModel.wallet.value!.balance.toStringAsFixed(2)} ${'QAR'.tr}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConst.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionCard(transaction: transaction);
              },
            ),
          ),
        ],
      ),
    );
  }
}