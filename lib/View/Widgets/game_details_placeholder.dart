import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Helper/app_const.dart';
import '../../ViewModel/settings_view_model.dart';


class GameDetailsPlaceholder extends StatelessWidget {

  const GameDetailsPlaceholder({super.key,});

  @override
  Widget build(BuildContext context) {

    final backgroundColor = Get.isDarkMode ? AppConst.darkSurfaceColor : AppConst.lightSurfaceColor;
    final placeholderColor = Get.isDarkMode ? Colors.white12 : const Color(0xFFE0E0E0);

    return Column(
      children: [
        // Status Card
        Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    shape: BoxShape.circle,
                  ),
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 14,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          color: placeholderColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 80,
                  height: 30,
                ),
              ],
            ),
          ),
        ),

        // Vehicle Information
        _buildSectionPlaceholder(
          backgroundColor: backgroundColor,
          placeholderColor: placeholderColor,
          icon: Icons.local_shipping,
          rows: 3,
        ),

        // Location Details
        _buildSectionPlaceholder(
          backgroundColor: backgroundColor,
          placeholderColor: placeholderColor,
          icon: Icons.location_on,
          customContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInfoPlaceholder(placeholderColor),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Container(
                        width: 2,
                        height: 2,
                        color: placeholderColor,
                      ),
                    ),
                  ),
                ),
              ),
              _buildLocationInfoPlaceholder(placeholderColor),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 14,
                    decoration: BoxDecoration(
                      color: placeholderColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: placeholderColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Time Details
        _buildSectionPlaceholder(
          backgroundColor: backgroundColor,
          placeholderColor: placeholderColor,
          icon: Icons.access_time,
          rows: 1,
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionPlaceholder({
    required Color backgroundColor,
    required Color placeholderColor,
    required IconData icon,
    int rows = 1,
    Widget? customContent,
  }) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (customContent != null)
              customContent
            else
              Column(
                children: List.generate(
                  rows,
                      (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 14,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 14,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoPlaceholder(Color placeholderColor) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: placeholderColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 14,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}