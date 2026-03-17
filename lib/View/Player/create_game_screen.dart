import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Helper/app_const.dart';
import '../../Helper/game_characteristics.dart';
import '../../ViewModel/game_view_model.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final GameViewModel gameViewModel = Get.find<GameViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController matchDateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController mapUrlController = TextEditingController();
  final TextEditingController playersPerTeamController =
      TextEditingController(text: '5');
  final TextEditingController matchDurationController =
      TextEditingController(text: '90');

  String selectedGameType = 'Football';
  bool goalkeeperAvailability = false;
  bool refereeAvailability = false;
  bool waterAvailability = false;
  DateTime? matchDate;
  List<String> selectedCharacteristics = [];

  @override
  void dispose() {
    matchDateController.dispose();
    priceController.dispose();
    placeNameController.dispose();
    descriptionController.dispose();
    mapUrlController.dispose();
    playersPerTeamController.dispose();
    matchDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(
          'Create New Game'.tr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<GameViewModel>(
        builder: (_) {
          return ModalProgressHUD(
            inAsyncCall: gameViewModel.isCreating,
            progressIndicator: CircularProgressIndicator(
              color: AppConst.primaryColor,
            ),
            opacity: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Game Type
                    _buildSectionTitle('Sport Type'.tr),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Football', 'Padel'].map((type) {
                        final isSelected = selectedGameType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => selectedGameType = type),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppConst.primaryColor
                                    : AppConst.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppConst.primaryColor
                                      : Colors.transparent,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  type.tr,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppConst.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Match Date
                    _buildSectionTitle('Match Date'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Match Date'.tr,
                      readOnly: true,
                      textEditingController: matchDateController,
                      prefixIcon:
                          const Icon(Icons.calendar_today, color: Colors.grey),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            matchDate = DateTime(date.year, date.month,
                                date.day, time.hour, time.minute);
                            matchDateController.text =
                                DateFormat('yyyy-MM-dd HH:mm').format(matchDate!);
                          }
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a match date'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Match Duration
                    _buildSectionTitle('Match Duration (minutes)'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Match Duration (minutes)'.tr,
                      inputType: TextInputType.number,
                      textEditingController: matchDurationController,
                      prefixIcon:
                          const Icon(Icons.access_time, color: Colors.grey),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter match duration'.tr;
                        }
                        final v = int.tryParse(value);
                        if (v == null || v <= 0) {
                          return 'Please enter a valid duration'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Players Per Team
                    _buildSectionTitle('Players Per Team'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Players Per Team'.tr,
                      inputType: TextInputType.number,
                      textEditingController: playersPerTeamController,
                      prefixIcon:
                          const Icon(Icons.group, color: Colors.grey),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter players per team'.tr;
                        }
                        final v = int.tryParse(value);
                        if (v == null || v <= 0) {
                          return 'Please enter a valid number'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Place Name
                    _buildSectionTitle('Stadium Name'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Stadium Name'.tr,
                      textEditingController: placeNameController,
                      prefixIcon:
                          const Icon(Icons.stadium, color: Colors.grey),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a stadium name'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price
                    _buildSectionTitle('Price'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Price'.tr,
                      inputType: TextInputType.number,
                      textEditingController: priceController,
                      prefixIcon:
                          const Icon(Icons.attach_money, color: Colors.grey),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price'.tr;
                        }
                        final v = double.tryParse(value);
                        if (v == null || v < 0) {
                          return 'Please enter a valid price'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Map URL
                    _buildSectionTitle('Map URL'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Map URL (optional)'.tr,
                      textEditingController: mapUrlController,
                      prefixIcon:
                          const Icon(Icons.map_outlined, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _buildSectionTitle('Description'.tr),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: 'Description (optional)'.tr,
                      textEditingController: descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Services
                    _buildSectionTitle('Available Services'.tr),
                    const SizedBox(height: 8),
                    _buildServiceToggle(
                      label: 'Goalkeeper'.tr,
                      icon: '🥅',
                      value: goalkeeperAvailability,
                      onChanged: (v) =>
                          setState(() => goalkeeperAvailability = v),
                    ),
                    _buildServiceToggle(
                      label: 'Referee'.tr,
                      icon: '👨‍⚖️',
                      value: refereeAvailability,
                      onChanged: (v) =>
                          setState(() => refereeAvailability = v),
                    ),
                    _buildServiceToggle(
                      label: 'Water'.tr,
                      icon: '💧',
                      value: waterAvailability,
                      onChanged: (v) =>
                          setState(() => waterAvailability = v),
                    ),
                    const SizedBox(height: 16),

                    // Venue Features
                    _buildSectionTitle('Venue Features'.tr),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: GameCharacteristic.values.map((characteristic) {
                        final isSelected = selectedCharacteristics
                            .contains(characteristic.value);
                        return FilterChip(
                          label: Text(characteristic.displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedCharacteristics
                                    .add(characteristic.value);
                              } else {
                                selectedCharacteristics
                                    .remove(characteristic.value);
                              }
                            });
                          },
                          selectedColor:
                              AppConst.primaryColor.withOpacity(0.2),
                          checkmarkColor: AppConst.primaryColor,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    CustomButton(
                      text: 'Add Game'.tr,
                      onPressed: _onSubmit,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildServiceToggle({
    required String label,
    required String icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$icon  $label'),
      value: value,
      activeColor: AppConst.primaryColor,
      onChanged: onChanged,
    );
  }

  Future<void> _onSubmit() async {
    if (!formKey.currentState!.validate()) return;
    if (matchDate == null) {
      Get.snackbar(
        'Error'.tr,
        'Please select a match date'.tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    final success = await gameViewModel.createGame(
      matchDate: matchDate!,
      matchDuration: int.parse(matchDurationController.text),
      gameType: selectedGameType,
      placeName: placeNameController.text.trim(),
      price: double.parse(priceController.text),
      playersPerTeam: int.parse(playersPerTeamController.text),
      goalkeeperAvailability: goalkeeperAvailability,
      refereeAvailability: refereeAvailability,
      waterAvailability: waterAvailability,
      characteristics: selectedCharacteristics,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      mapUrl: mapUrlController.text.trim().isEmpty
          ? null
          : mapUrlController.text.trim(),
    );

    if (success) {
      Get.back();
    }
  }
}
