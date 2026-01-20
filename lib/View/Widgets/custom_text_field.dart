import '../../ViewModel/settings_view_model.dart';
import '/Helper/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, required this.hintText,this.inputType = TextInputType.text, this.validator, this.onSaved, this.suffixIcon, this.initValue, this.readOnly = false, this.onTap, this.textEditingController, this.prefixIcon, this.maxLines = 1, this.maxLength, });
  final String hintText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? initValue;
  final bool? readOnly;
  final TextEditingController? textEditingController;
  final int? maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: inputType,
      validator: validator,
      onSaved: onSaved,
      obscureText: inputType == TextInputType.visiblePassword,
      initialValue: initValue,
      readOnly: readOnly ?? false,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
      style: TextStyle(
        fontWeight: FontWeight.w500,

      ),
      decoration: InputDecoration(
          alignLabelWithHint: true,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          filled: true,
          hintStyle: const TextStyle(color: Colors.grey,),
          errorStyle: const TextStyle(fontWeight: FontWeight.w500,),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  style: BorderStyle.none,
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                style: BorderStyle.none,
              )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                style: BorderStyle.none,
              )
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                style: BorderStyle.none,
              )
          ),
      ),
    );
  }
}
