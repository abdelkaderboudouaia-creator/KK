import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qplay/Helper/app_routes.dart';
import 'package:qplay/View/account_blocked.dart';
import 'package:qplay/ViewModel/notification_view_model.dart';

import '../Helper/app_const.dart';
import '../Model/user_model.dart';
import '../View/Widgets/custom_message_dialog.dart';
import 'Api/auth_api.dart';
import 'user_view_model.dart';

/// GetX controller responsible for all authentication flows.
///
/// Manages:
/// * **Email/password login** ([login])
/// * **Google Sign-In** ([loginWithGoogle])
/// * **Registration** ([register])
/// * **Password reset** – forget password → OTP verification → reset
///   ([forgetPassword], [verifyOTP], [resetPassword])
/// * **Change password** while authenticated ([changePassword])
/// * **Logout** ([logout])
///
/// Temporary form field values (e.g. [email], [password]) are stored directly
/// on this controller so they are shared across the Auth screens without
/// needing extra state.  [loading] drives the `ModalProgressHUD` shown on
/// each Auth screen.
class AuthViewModel extends GetxController {
  AuthApi authApi = AuthApi();

  GoogleSignIn googleSignIn = GoogleSignIn();

  String firstName = '';
  String lastName = '';
  String countryCode = '';
  String phone = '';
  String email = '';
  String password = '';
  DateTime? birthday;

  String otp = '';

  bool loading = false;

  Future<void> login() async {
    loading = true;
    update();

    try {
      // Get device info
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel = 'Unknown';
      String deviceType = Platform.isAndroid ? 'Android' : 'iOS';

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.model;
      }

      String? deviceToken = await getPushToken();

      var r = await authApi.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
        deviceModel: deviceModel,
        deviceType: deviceType,
      );

      if (r.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(r.body);
        final UserViewModel userViewModel = Get.find<UserViewModel>();
        userViewModel.user = UserModel.fromJson(json['user']);
        if (userViewModel.user!.isBlocked) {
          throw ('user block');
        }
        await AppConst.prefs.setString('token', json['token']);
        await AppConst.prefs.setInt('userId', userViewModel.user!.id);
        Get.offAllNamed(Routes.HOME);
        Get.find<NotificationViewModel>().connect();
      } else if (r.statusCode == 401) {
        showCustomMessageDialog('Wrong email or password'.tr, Type.error);
      } else {
        showCustomMessageDialog('Login failed. Please try again.'.tr, Type.error);
      }
    } catch (e) {
      if (e.toString().contains('user block')) {
        Get.offAll(() => AccountBlocked());
      }
      else{
        showCustomMessageDialog('An error occurred. Please try again.'.tr, Type.error);
      }
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> loginWithGoogle() async {
    loading = true;
    update();
    try {
      await googleSignIn.signOut();
      GoogleSignInAuthentication? googleSignInAuthentication =
      await (await googleSignIn.signIn())?.authentication;

      if (googleSignInAuthentication != null) {
        // Get device info
        final deviceInfo = DeviceInfoPlugin();
        String deviceModel = 'Unknown';
        String deviceType = Platform.isAndroid ? 'Android' : 'iOS';

        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceModel = androidInfo.model;
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.model;
        }

        // Get FCM token if available
        String? deviceToken = await getPushToken();


        final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        var userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        var r = await authApi.loginWithGoogle(
          idToken: (await userCredential.user?.getIdToken()) ?? '',
          deviceToken: deviceToken,
          deviceModel: deviceModel,
          deviceType: deviceType,
        );

        if (r.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(r.body);
          final UserViewModel userViewModel = Get.find<UserViewModel>();
          userViewModel.user = UserModel.fromJson(json['user']);
          await AppConst.prefs.setString('token', json['token']);
          await AppConst.prefs.setInt('userId', userViewModel.user!.id);
          if (userViewModel.user!.isBlocked) {
            throw ('user block');
          }
          Get.find<NotificationViewModel>().connect();
          Get.offAllNamed(Routes.HOME);
        } else if (r.statusCode == 201) {
          var json = jsonDecode(r.body);
          firstName = json['first_name'];
          lastName = json['last_name'];
          email = json['email'];
          Get.toNamed(Routes.REGISTER);
        }
      }
    } catch (e) {
      if (e.toString().contains('user block')) {
        Get.offAll(() => AccountBlocked());
      } else {
        showCustomMessageDialog('Google login failed. Please try again.'.tr, Type.error);
      }
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> register() async {
    loading = true;
    update();

    try {
      var r = await authApi.register(
        firstName: firstName,
        lastName: lastName,
        birthday: birthday,
        countryCode: countryCode,
        phone: phone,
        email: email,
        password: password,
      );
      if (r.statusCode == 200) {
        Get.offNamed(Routes.LOGIN);
        Get.snackbar('Success'.tr, 'Account created successfully'.tr,backgroundColor: Colors.green,colorText: Colors.white,);
      } else if (r.statusCode == 409) {
        Get.snackbar('Error'.tr, 'Email already used'.tr,backgroundColor: Colors.red,colorText: Colors.white,);
      }
    } catch (e) {
      //
    }
    loading = false;
    update();
  }

  Future<void> forgetPassword() async {
    loading = true;
    update();
    try {
      var r = await authApi.forgetPassword(email);
      print(r.body);
      if (r.statusCode == 200) {
        Get.toNamed('/verify-otp?resetId=${jsonDecode(r.body)['reset_id']}');
      } else if (r.statusCode == 404) {
        showCustomMessageDialog("Email not found".tr, Type.error);
      } else {
        showCustomMessageDialog(
            "An error occurred, please try again later".tr, Type.error);
      }
    } catch (e) {
      //
    }
    loading = false;
    update();
  }

  Future<void> verifyOTP(int resetId) async {
    loading = true;
    update();
    try {
      var r = await authApi.verifyOTP(email: email, resetId: resetId, otp: otp);
      if (r.statusCode == 200) {
        Get.toNamed('/reset-password?token=${jsonDecode(r.body)['token']}');
      } else if (r.statusCode == 500) {
        return await verifyOTP(resetId);
      } else {
        showCustomMessageDialog('Invalid OTP'.tr, Type.error);
      }
    } catch (e) {
      if (e.toString().contains('user block')) {
        Get.toNamed('/account-blocked');
      } else if (e.toString().contains('Network is unreachable') ||
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('No route to host') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection failed')) {
        showCustomMessageDialog('Check your connectivity'.tr, Type.error);
      }
    }
    loading = false;
    update();
  }

  Future<void> resetPassword(
      {required String token, required String newPassword}) async {
    loading = true;
    update();
    try {
      var r =
          await authApi.resetPassword(token: token, newPassword: newPassword);
      if (r.statusCode == 200) {
        Get.offAllNamed(Routes.LOGIN);
        showCustomMessageDialog(
          "Password changed successfully".tr,
          Type.success,
        );
      } else if (r.statusCode == 400) {
        Get.offAllNamed(Routes.FORGET_PASSWORD);
      } else {
        showCustomMessageDialog(
            "An error occurred, please try again later".tr, Type.error);
      }
    } catch (e) {
      //
    }
    loading = false;
    update();
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    loading = true;
    update();
    try {
      var r = await authApi.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);
      if (r.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(r.body);
        final UserViewModel userViewModel = Get.find<UserViewModel>();
        userViewModel.user = UserModel.fromJson(json['user']);
        await AppConst.prefs.setString('token', json['token']);
        loading = false;
        update();
        Get.back();
        showCustomMessageDialog(
          "Password changed successfully".tr,
          Type.success,
        );
      } else if (r.statusCode == 401) {
        showCustomMessageDialog(
          "Current password is incorrect".tr,
          Type.error,
        );
      } else {
        showCustomMessageDialog(
            "An error occurred, please try again later".tr, Type.error);
      }
    } catch (e) {
      //
    }
    loading = false;
    update();
  }

  Future<void> logout() async {
    try {
      var r = await authApi.logout();
      if (r.statusCode == 200) {
        await AppConst.prefs.remove('token');
        await AppConst.restartViewModel();
        Get.offAllNamed(Routes.LOGIN);
        Get.find<NotificationViewModel>().disconnect();
      }
    } catch (e) {}
  }


  Future<String?> getPushToken() async{
    try{
      FirebaseMessaging fcm = FirebaseMessaging.instance;
      String? token;
      if(AppConst.prefs.getString('pushToken') != null){
        token = AppConst.prefs.getString('pushToken');
      }
      else{
        token = await fcm.getToken();
      }
      if(token != null){
        await AppConst.prefs.setString('pushToken', token);
      }
      return token;
    }
    catch(e){


      //
    }
    return null;
  }
}
