import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Model/wallet_model.dart';
import 'package:qplay/Model/wallet_transaction_model.dart';
import 'package:qplay/ViewModel/Api/Exceptions/api_exception.dart';
import 'package:qplay/ViewModel/api/payment_api.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

/// GetX controller that handles wallet top-ups and transaction history.
///
/// * [createPayment] – creates a payment via the SkipCash gateway and opens
///   the returned [payUrl] in the device's default browser.
/// * [getTransactions] – fetches the authenticated user's [WalletModel]
///   (including the full list of [WalletTransactionModel] entries).
/// * [getTransaction]  – fetches details for a single transaction by ID.
///
/// [wallet] is a reactive nullable value; the Wallet screen observes it to
/// display the current balance.  [isLoading] and [errorMessage] are used
/// for UI feedback.
class PaymentViewModel extends GetxController {
  final PaymentApi _paymentApi = PaymentApi();

  Rxn<WalletModel> wallet = Rxn<WalletModel>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> createPayment({
    required double amount,
  }) async {
    try {
      errorMessage.value = '';

      final response = await _paymentApi.createPayment(amount: amount);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentUrl = data['payment_url'];

        if (paymentUrl != null) {
          await _launchPaymentUrl(paymentUrl);
        }
      }
      else  {
        errorMessage.value = 'An error occurred, please try again later'.tr;
        Get.snackbar(
            'Error'.tr,
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      }
    } catch (e) {
      errorMessage.value = 'Check your connectivity'.tr;
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
    }
  }

  Future<void> _launchPaymentUrl(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Could not open payment page'.tr,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> getTransactions() async {
    isLoading.value = true;
    update();
    try {
      var r = await _paymentApi.getTransactions();
      print(r.body);
      if (r.statusCode == 200) {
        wallet.value = WalletModel.fromJson(jsonDecode(r.body));
      }
    } on ApiException catch (_) {
      //
    } finally {
      isLoading.value = false;
      update();
    }
  }


  Future<WalletTransactionModel?> getTransaction(int transactionId) async {
    try {
      var r = await _paymentApi.getTransaction(transactionId);
      print(r.body);
      if (r.statusCode == 200) {
        return WalletTransactionModel.fromJson(jsonDecode(r.body));
      }

    } catch (e) {
      if (e.toString().contains('Network is unreachable') ||
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('No route to host') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection failed') ||
          e.toString().contains('Connection refused')) {
        Get.snackbar(
            'Error'.tr,
            'An error occurred, please try again later'.tr,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      }
    }
    return null;
  }
}