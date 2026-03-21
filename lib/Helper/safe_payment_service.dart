import 'dart:convert';

import 'package:qplay/Helper/app_const.dart';
import 'package:qplay/ViewModel/Api/payment_api.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service that provides safe (crash-resilient) payment initiation and
/// pending-payment tracking across app lifecycle events.
///
/// A payment is considered *pending* once the external browser has been
/// opened to complete it.  The payment ID is persisted in [SharedPreferences]
/// under [_pendingPaymentKey] so it survives app restarts and can be
/// verified when the user returns to the app.
///
/// Typical usage:
/// ```dart
/// final success = await SafePaymentService.initiatePayment(amount: 50.0);
/// if (!success) {
///   // show error
/// }
///
/// // When the app resumes (from WidgetsBindingObserver):
/// final id = await SafePaymentService.getPendingPaymentId();
/// if (id != null) {
///   final status = await PaymentApi.getPaymentStatus(id);
///   // handle status ...
///   await SafePaymentService.clearPendingPayment();
/// }
/// ```
class SafePaymentService {
  static const String _pendingPaymentKey = 'pending_payment_id';

  /// Returns the ID of the last payment that was opened in the external
  /// browser, or `null` if there is no pending payment.
  static Future<String?> getPendingPaymentId() async {
    return AppConst.prefs.getString(_pendingPaymentKey);
  }

  /// Removes the stored pending payment ID.
  ///
  /// Call this after the payment status has been confirmed (paid, cancelled,
  /// or failed) so the same payment is not re-checked on the next app resume.
  static Future<void> clearPendingPayment() async {
    await AppConst.prefs.remove(_pendingPaymentKey);
  }

  /// Creates a payment via the backend and opens the SkipCash gateway in an
  /// external browser.
  ///
  /// Persists the returned payment ID in [SharedPreferences] before launching
  /// the browser so the app can verify the outcome when it resumes.
  ///
  /// [amount] is the payment amount.  The optional [transactionId] is sent as
  /// the `custom1` field and can be used to correlate the payment with an
  /// internal order.
  ///
  /// The backend response is expected to contain `payment_url` and either a
  /// `payment_id` or `id` field for the newly created payment record.
  ///
  /// Returns `true` if the browser was successfully opened, `false` otherwise.
  static Future<bool> initiatePayment({
    required double amount,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? transactionId,
  }) async {
    try {
      final api = PaymentApi();
      final response = await api.createPayment(
        amount: amount,
        custom1: transactionId,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final paymentUrl = data['payment_url'] as String?;
        final paymentId =
            (data['payment_id'] ?? data['id'])?.toString();

        if (paymentUrl != null) {
          if (paymentId != null) {
            await AppConst.prefs.setString(_pendingPaymentKey, paymentId);
          }
          await launchUrl(
            Uri.parse(paymentUrl),
            mode: LaunchMode.externalApplication,
          );
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
