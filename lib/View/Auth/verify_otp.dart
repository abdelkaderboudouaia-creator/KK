import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../Helper/app_const.dart';
import '../../ViewModel/auth_view_model.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_button.dart';

/// OTP verification screen – step 2 of the password-reset flow.
///
/// Displays a 6-digit OTP input ([OtpTextField]) and a 30-second countdown
/// timer.  When the timer reaches zero, a "Resend" button becomes active.
///
/// Submitting a valid OTP calls [AuthViewModel.verifyOTP] which, on success,
/// navigates to [ResetPassword] with the reset token.
class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final AuthViewModel authViewModel = Get.put(AuthViewModel());

  bool submit = false;
  RxInt sec = 30.obs;

  void startTimer() {
    sec.value = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec.value > 0) {
        sec.value--;
      } else {
        timer.cancel();
      }
    });
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AuthViewModel>(
          builder: (_) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ModalProgressHUD(
                  inAsyncCall: authViewModel.loading,
                  progressIndicator: CircularProgressIndicator(
                    color: AppConst.primaryColor,
                  ),
                  opacity: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'The OTP has been sent'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: OTPTextField(
                          length: 4,
                          width: 300,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 12,
                          fieldWidth: 60,
                          otpFieldStyle: OtpFieldStyle(
                            enabledBorderColor: AppConst.secondaryColor,
                            disabledBorderColor: AppConst.secondaryColor,
                            borderColor: AppConst.secondaryColor,
                            focusBorderColor: AppConst.secondaryColor,
                            errorBorderColor: AppConst.secondaryColor,
                          ),
                          style: TextStyle(
                            fontSize: 25
                          ),
                          textFieldAlignment: MainAxisAlignment.spaceEvenly,
                          onCompleted: (verificationCode) {
                            submit = true;
                            authViewModel.otp = verificationCode;
                          },
                        ),
                      ),
                      const SizedBox(
                        height:20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Resend the OTP in '.tr,
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          Obx(
                                () => sec.value > 0
                                ? Text(
                              '${sec.value} ${'s'.tr}',
                              style: TextStyle(
                                color: AppConst.secondaryColor,
                                  fontSize: 14
                              ),
                            )
                                : CustomTextButton(
                              text: 'resend'.tr,
                              onTap: () async{
                                authViewModel.forgetPassword();
                                startTimer();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        onPressed: () async {
                          if(submit){
                            int resetId = int.tryParse(Get.parameters['resetId'] ?? '') ?? 0;
                            await authViewModel.verifyOTP(resetId);
                          }
                        },
                        text: 'Verify'.tr,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    
    );
  }
}
