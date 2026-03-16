import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Helper/app_const.dart';

/// Low-level HTTP client for all authentication endpoints.
///
/// Each method maps 1-to-1 to a backend REST endpoint:
///
/// | Method              | HTTP | Endpoint                  |
/// |---------------------|------|---------------------------|
/// | [register]          | POST | `/register`               |
/// | [login]             | POST | `/login`                  |
/// | [loginWithGoogle]   | POST | `/login-with-google`      |
/// | [forgetPassword]    | GET  | `/forgot-password`        |
/// | [verifyOTP]         | POST | `/verify-otp`             |
/// | [resetPassword]     | POST | `/reset-password`         |
/// | [changePassword]    | POST | `/change-password`        |
/// | [logout]            | POST | `/logout`                 |
///
/// All requests include `Accept: application/json`.  Authenticated requests
/// attach `Authorization: Bearer <token>` from [AppConst.prefs].
class AuthApi {

  Future<http.Response> register({
    required String firstName,
    required String lastName,
    DateTime? birthday,
    required String countryCode,
    required String phone,
    required String email,
    required String password,
  }) async {
    return await http.post(
      Uri.parse('${AppConst.endPoint}/register'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'first_name' : firstName,
        'last_name' : lastName,
        'country_code' : countryCode,
        'phone' : phone,
        'email' : email,
        'password' : password,
        'birthday' : birthday?.toIso8601String()
      }),
    );

  }

  Future<http.Response> forgetPassword(String email) async{

    final response = await http.get(
      Uri.parse('${AppConst.endPoint}/forgot-password?email=$email'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );
    return response;
  }

  Future<http.Response> login({
    required String email,
    required String password,
    String? deviceToken,
    String? deviceModel,
    String? deviceType,
  }) async {
    return await http.post(
      Uri.parse('${AppConst.endPoint}/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_token': deviceToken,
        'device_model': deviceModel,
        'device_type': deviceType,
      }),
    );
  }

  Future<http.Response> loginWithGoogle({
    required String idToken,
    String? deviceToken,
    String? deviceModel,
    String? deviceType,
  }) async {
    return await http.post(
      Uri.parse('${AppConst.endPoint}/login-with-google'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'idToken': idToken,
        'device_token': deviceToken,
        'device_model': deviceModel,
        'device_type': deviceType,
      }),
    );
  }

  Future<http.Response> verifyOTP({required String email,required String otp,required int resetId}) async{
    final response = await http.post(
        Uri.parse('${AppConst.endPoint}/verify-otp'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email' : email,
          'otp' : otp,
          'reset_id' : resetId
        })
    );
    return response;
  }

  Future<http.Response> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConst.endPoint}/reset-password'), // Replace with your endpoint
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'token': token,
        'new_password': newPassword,
      }),
    );

    return response;
  }

  Future<http.Response> changePassword({required String currentPassword,required String newPassword}) async{
    final response = await http.post(
        Uri.parse('${AppConst.endPoint}/change-password'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
        },
        body: {
          'current_password' : currentPassword,
          'new_password' : newPassword,
        }

    );
    return response;
  }

  Future<http.Response> logout() async{
    return await http.post(Uri.parse('${AppConst.endPoint}/logout'),
      headers: {'Accept': 'application/json','Authorization': 'Bearer ${AppConst.prefs.getString('token')}'},
    );
  }
}
