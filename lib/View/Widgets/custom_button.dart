import '/Helper/app_const.dart';
import 'package:flutter/material.dart';

/// A styled primary action button used throughout the app.
///
/// [text] is the button label.  [color] overrides the default
/// [AppConst.primaryColor].  [onPressed] is `null`-safe – when `null` the
/// button is disabled.
class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.color,required this.onPressed});
  final String text;
  final Color? color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color ?? AppConst.primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),),
        child: Text(text,style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}
