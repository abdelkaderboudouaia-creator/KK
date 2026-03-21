import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Import the intl_phone_field package
import 'package:intl_phone_field/phone_number.dart';

import '../../Helper/app_const.dart';
import '../../ViewModel/settings_view_model.dart';

/// An international phone-number input widget backed by [IntlPhoneField].
///
/// Displays a country-code selector flag and text field.  The field
/// automatically validates the format for the selected country.
/// [onChanged] receives the full [PhoneNumber] object (country code + number).
/// [validator] allows custom validation logic on top of the built-in check.
class PhoneNumberField extends StatelessWidget {
  PhoneNumberField({
    super.key,
    this.inputType,
    this.validator,
    this.onSaved,
    this.suffixIcon,
    this.initValue,
    required this.initialCountryCode,
    this.readOnly,
    this.onChanged,
    this.controller,
  });

  final TextInputType? inputType;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber?)? onSaved;
  final IconData? suffixIcon;
  final String? initValue;
  final String initialCountryCode;
  final bool? readOnly;
  final void Function(PhoneNumber)? onChanged;
  final TextEditingController? controller;

  final SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        initialValue: initValue,
        dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        invalidNumberMessage: 'Wrong phone number'.tr,
        searchText: 'Search country'.tr,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone, color: Colors.grey),
          hintText: 'Phone Number'.tr,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        initialCountryCode: countries.where((e)=>e.dialCode == initialCountryCode.substring(1)).first.code,
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        readOnly: readOnly ?? false,
      ),
    );
  }
}