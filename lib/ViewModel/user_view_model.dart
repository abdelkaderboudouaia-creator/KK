import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:qplay/View/account_blocked.dart';
import 'package:qplay/ViewModel/settings_view_model.dart';
import '../Helper/app_const.dart';
import '../Helper/app_routes.dart';
import '../Model/user_model.dart';
import '../View/Widgets/custom_message_dialog.dart';
import 'Api/user_api.dart';
import 'notification_view_model.dart';
class UserViewModel extends GetxController {




  bool get isLoggedIn => AppConst.prefs.getString('token') != null;

  bool loading = false;

  UserApi userApi = UserApi();

  UserModel? user;

  dynamic photo;

  bool isNewVersion = false;

  Future<UserModel?> initUser() async {
    if (AppConst.prefs.getString('token') == null) {
      return null;
    }
    try {
      var r = await userApi.getUser();
      if (r.statusCode == 200) {
        user = UserModel.fromJson(jsonDecode(r.body));
        if (user!.isBlocked) {
          throw ('user block');
        }
      } else if (r.statusCode == 401) {
        return null;
      } else if (r.statusCode == 500) {
        await Future.delayed(const Duration(milliseconds: 1000));
        return await initUser();
      }
    } catch (e) {
      if (e.toString().contains('user block')) {
        Get.offAll(() => AccountBlocked());
      }
      else{
        return null;
      }

    }
    return user;
  }

  Future<UserModel?> getUser() async {
    try {
      if (AppConst.prefs.getString('token') == null) {
        Get.toNamed('/login');
        return null;
      }
      var r = await userApi.getUser().timeout(const Duration(seconds: 10));
      if (r.statusCode == 200) {
        user = UserModel.fromJson(jsonDecode(r.body));
        if (user!.isBlocked) {
          throw ('user block');
        }
        await Get.find<SettingsViewModel>().setLocal(user!.language);
        if(NotificationViewModel.redirectRoute != null){
          Get.offAllNamed(NotificationViewModel.redirectRoute!);
          NotificationViewModel.redirectRoute = null;
        }
        else{
          Get.toNamed(Routes.HOME);
        }
      } else if (r.statusCode == 500) {
        return await getUser();
      } else {
        await AppConst.prefs.remove('token');
        Get.toNamed(Routes.LOGIN);
      }
    } catch (e) {
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('No route to host') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection failed')) {
        if (!(Get.isDialogOpen ?? true)) {
          showCustomMessageDialog('Check your connectivity'.tr, Type.error);
        }
        return await getUser();
      } else if(e.toString().contains('user block')){
        Get.offAllNamed('/account-blocked');
      } else {
        //showCustomMessageDialog("An error occurred, please try again later".tr,Type.error);
      }
    }
    return user;
  }


  Future<void> updateUser({
        String? username,
        String? firstName,
        String? lastName,
        String? countryCode,
        String? phone,
        DateTime? birthday,
        String? language,
        File? photo,
        String? pushToken
      }) async {
    loading = true;
    update();

    try {
      var r = await userApi.updateUser(
          username: username,
          firstName: firstName,
          lastName: lastName,
          countryCode: countryCode,
          phone: phone,
          language: language,
          pushToken: pushToken,
          birthday: birthday,
        photo: photo
      );

      if (r.statusCode == 200) {
        user = UserModel.fromJson(jsonDecode(r.body));
        if (Get.currentRoute == Routes.EDIT_PROFILE) {
          Get.back();
          showCustomMessageDialog(
              'Profile updated successfully'.tr, Type.success);
        }
      } else if (r.statusCode == 409) {
        if (Get.currentRoute == Routes.EDIT_PROFILE) {
          showCustomMessageDialog('Username already taken'.tr, Type.error);
        }
      } else {
        if (Get.currentRoute == Routes.EDIT_PROFILE) {
          showCustomMessageDialog('An error occurred, please try again later'.tr, Type.error);
        }
      }
    } catch (e) {
      //
    }
    loading = false;
    update();
  }



}
