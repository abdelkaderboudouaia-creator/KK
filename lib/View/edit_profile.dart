import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qplay/View/Widgets/custom_profile_pic.dart';
import 'package:badges/badges.dart';
import '../../../Helper/app_const.dart';
import '../../../ViewModel/settings_view_model.dart';
import '../../../ViewModel/user_view_model.dart';
import '/View/Widgets/custom_button.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'Widgets/custom_text_field.dart';
import 'Widgets/phone_number_field.dart';

/// Screen that lets the authenticated user update their profile information.
///
/// Fields: first name, last name, username, phone number, birthday, and
/// profile photo (picked from gallery or camera via [ImagePicker]).
///
/// On submission the data is sent to the backend through
/// [UserViewModel.updateUser].  A loading overlay ([ModalProgressHUD]) is
/// shown while the request is in flight.
class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
  final UserViewModel userViewModel = Get.put(UserViewModel());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String firstName, lastName, phone, username, countryCode;
  File? photo;
  DateTime? birthday;
  late TextEditingController birthdayController;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userViewModel.loading = false;
    username = userViewModel.user!.username;
    firstName = userViewModel.user!.firstName;
    lastName = userViewModel.user!.lastName;
    phone = userViewModel.user!.phone;
    countryCode = userViewModel.user!.countryCode;
    birthday = DateTime.tryParse(userViewModel.user!.birthday ?? '');
    birthdayController = TextEditingController(
        text: userViewModel.user!.birthday != null
            ? "${userViewModel.user!.birthday}".split(' ')[0]
            : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GetBuilder<UserViewModel>(
        builder: (_) {
          return ModalProgressHUD(
            inAsyncCall: userViewModel.loading,
            progressIndicator: CircularProgressIndicator(
              color: AppConst.primaryColor,
            ),
            opacity: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Badge(
                        position: BadgePosition.bottomEnd(bottom: -0, end: -0),
                        badgeStyle: BadgeStyle(
                          badgeColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.all(6),
                          shape: BadgeShape.circle,
                          borderSide: const BorderSide(color: Colors.white, width: 2),
                        ),
                        badgeContent: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: pickImageFromGallery,
                          child: ClipOval(
                            child: photo == null
                                ? CustomProfilePic(
                              url: userViewModel.user!.photo,
                              size: 100,
                              name: firstName,
                            )
                                : Image.file(
                              photo!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hintText: 'First Name'.tr,
                            inputType: TextInputType.text,
                            prefixIcon: const Icon(Icons.person_outline,
                                color: Colors.grey),
                            initValue: userViewModel.user!.firstName,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return 'Enter first name'.tr;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              firstName = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: 'Last Name'.tr,
                            inputType: TextInputType.text,
                            prefixIcon: const Icon(Icons.person_pin_outlined,
                                color: Colors.grey),
                            initValue: userViewModel.user!.lastName,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return 'Enter last name'.tr;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              lastName = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: 'Username'.tr,
                            inputType: TextInputType.text,
                            prefixIcon: const Icon(Icons.alternate_email,
                                color: Colors.grey),
                            initValue: userViewModel.user!.username,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter username'.tr;
                              } else if (value.length < 6) {
                                return 'Username must be at least 6 characters'
                                    .tr;
                              }
                              print(value);
                              final RegExp usernameRegExp =
                                  RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._]{2,19}$');

                              if (!usernameRegExp.hasMatch(value)) {
                                return 'Invalid username. Use letters, numbers, underscores, or periods'
                                    .tr;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              username = value!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Birthday".tr,
                            readOnly: true,
                            textEditingController: birthdayController,
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: Colors.grey),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000, 1, 1),
                                firstDate: DateTime(1980),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  birthdayController.text =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                            onSaved: (value) {
                              if (value != null)
                                birthday = DateTime.tryParse(value);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PhoneNumberField(
                            initValue: userViewModel.user!.phone,
                            initialCountryCode: userViewModel.user!.countryCode,
                            onSaved: (value) {
                              phone = value!.number;
                              countryCode = value.countryCode;
                            },
                          ),
                          CustomTextField(
                            hintText: 'Enter email'.tr,
                            inputType: TextInputType.emailAddress,
                            initValue: userViewModel.user!.email,
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.grey),
                            readOnly: true,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter email'.tr;
                              } else if (!GetUtils.isEmail(value)) {
                                return 'Wrong email'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomButton(
                            text: 'Save'.tr,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                bool hasChanged = username !=
                                        userViewModel.user!.username ||
                                    firstName !=
                                        userViewModel.user!.firstName ||
                                    lastName != userViewModel.user!.lastName ||
                                    phone != userViewModel.user!.phone ||
                                    countryCode !=
                                        userViewModel.user!.countryCode ||
                                    birthday?.toIso8601String() !=
                                        userViewModel.user!.birthday;

                                if (hasChanged) {
                                  await userViewModel.updateUser(
                                      firstName: firstName,
                                      lastName: lastName,
                                      countryCode: countryCode,
                                      phone: phone,
                                      birthday: birthday,
                                      username: username,
                                    photo: photo
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        photo = File(image.path);
      });
    }
  }
}
