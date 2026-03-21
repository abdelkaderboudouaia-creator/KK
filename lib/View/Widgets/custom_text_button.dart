import 'package:flutter/material.dart';

import '../../Helper/app_const.dart';

/// A borderless text button styled with [AppConst.primaryColor].
///
/// Used for secondary actions like "Forgot password?" or "Sign Up" links.
/// [text] is the button label, [onTap] is the tap callback, and [fontSize]
/// overrides the default font size.
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
