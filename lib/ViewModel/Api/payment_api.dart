import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qplay/Helper/app_const.dart';
import 'package:qplay/ViewModel/Api/Exceptions/api_exception.dart';

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
