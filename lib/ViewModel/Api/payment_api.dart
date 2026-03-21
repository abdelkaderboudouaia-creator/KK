import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qplay/Helper/app_const.dart';
import 'package:qplay/ViewModel/Api/Exceptions/api_exception.dart';

/// Low-level HTTP client for payment and wallet endpoints.
///
/// | Method              | HTTP | Endpoint                     |
/// |---------------------|------|------------------------------|
/// | [createPayment]     | POST | `/create-payment`            |
/// | [getPaymentStatus]  | GET  | `/payment-status/:id`        |
/// | [getTransactions]   | GET  | `/transactions`              |
/// | [getTransaction]    | GET  | `/transactions/:id`          |
///
/// All requests are authenticated with the stored Bearer token.
/// The response from [createPayment] contains a `payment_url` that is
/// opened in an external browser by [PaymentViewModel].
class PaymentApi {



  Future<http.Response> createPayment({
    required double amount,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? custom1,
  }) async {
    return await http.post(
      Uri.parse('${AppConst.endPoint}/create-payment'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
      },
      body: jsonEncode({
        'amount': amount,
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'postal_code': postalCode,
        'custom1': custom1,
      }),
    );
  }

  /// Status ID returned by the backend to indicate a successfully paid payment.
  static const int statusPaid = 2;

  /// Status ID returned by the backend to indicate a cancelled payment.
  static const int statusCancelled = 3;

  /// Status ID returned by the backend to indicate a failed payment.
  static const int statusFailed = 4;

  /// Fetches the current status of a payment from the backend.
  ///
  /// Returns a decoded JSON map that includes a `success` boolean and, when
  /// successful, a `data` object containing at minimum a `statusId` integer:
  /// * `2` – Paid
  /// * `3` – Cancelled
  /// * `4` – Failed
  ///
  /// On a network error the returned map contains `{'success': false}`.
  static Future<Map<String, dynamic>> getPaymentStatus(
      String paymentId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConst.endPoint}/payment-status/$paymentId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Bearer ${AppConst.prefs.getString('token')}'
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return {
        'success': false,
        'message': 'Request failed with status ${response.statusCode}',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<http.Response> getTransactions() async {
    final uri = Uri.parse('${AppConst.endPoint}/transactions');
    return await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
      },
    );
  }

  Future<http.Response> getTransaction(int transactionId) async {
   return await http.get(
     Uri.parse('${AppConst.endPoint}/transactions/$transactionId'),
     headers: {
       'Accept': 'application/json',
       'Content-Type': 'application/json; charset=UTF-8',
       'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'

     },
   );
  }


}
