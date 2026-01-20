import 'package:flutter/material.dart';

import '../../Helper/app_const.dart';
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({Key? key, required this.text, this.onTap, this.fontSize}) : super(key: key);
  final String text;
  final double? fontSize;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
            color: AppConst.primaryColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
