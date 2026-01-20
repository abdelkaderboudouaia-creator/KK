import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Helper/app_const.dart';

class LoginWithSocialMedia extends StatelessWidget {
  const LoginWithSocialMedia({Key? key, required this.dark, required this.text, required this.onPressed}) : super(key: key);
  final bool dark;
  final String text;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width * 0.85,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15),
          color: dark ? Colors.grey.shade900 : Colors.white,
          boxShadow: [
            if (!dark )
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/google.png", height: 24),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: dark ? AppConst.darkTextColor : AppConst.lightTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
//network-request-failed