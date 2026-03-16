import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/View/Widgets/custom_text_field.dart';

import '../Helper/app_const.dart';

/// Displayed when the backend marks the user's account as blocked
/// ([UserModel.isBlocked] == `true`).
///
/// Back navigation is disabled ([WillPopScope]) so the user cannot bypass
/// the blocked state.  A support-contact prompt is shown.
class AccountBlocked extends StatelessWidget {
  const AccountBlocked({super.key});


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{ return false; },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/account-blocked.png',),
                const SizedBox(height: 20,),
                Text(
                  "Due to violation of the terms of service, Farya has banned your account".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Is there an error ?\ncontact us".tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(

                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20,),
                CustomTextField(hintText: '',initValue: 'qplay.application@gmail.com',readOnly: true,suffixIcon: Icon(Icons.mail,color: AppConst.primaryColor,),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
