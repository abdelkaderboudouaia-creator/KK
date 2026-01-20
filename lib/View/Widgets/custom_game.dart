import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qplay/Helper/game_characteristics.dart';
import 'package:qplay/Model/game_model.dart';
import '../../Helper/app_const.dart';

class CustomGame extends StatelessWidget {
  final GameModel game;

  const CustomGame({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: _getStatusColor(game).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(game),
                  color: _getStatusColor(game),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  game.isUpcoming ? 'UPCOMING'.tr : 'FINISHED'.tr,
                  style: TextStyle(
                    color: _getStatusColor(game),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  intl.DateFormat('MMM dd, HH:mm').format(DateTime.parse(game.matchDate)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatPrice(game.price),
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? AppConst.darkTextSecondaryColor
                        : AppConst.lightTextSecondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Teams
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _buildTeamBadge(game.teams![0].name.tr, Colors.red),
                        const SizedBox(height: 8),
                        _buildMissingPlayers(missingPlayers: game.teams![0].missingPlayers, color: Colors.red),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _buildTeamBadge(game.teams![1].name.tr, Colors.blue),
                        const SizedBox(height: 8),
                        _buildMissingPlayers(missingPlayers: game.teams![1].missingPlayers, color: Colors.blue),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Game Info
                Row(
                  children: [
                    _buildInfoRow(
                      icon: Icons.sports_baseball,
                      color: Colors.green,
                      text: game.gameType.tr,
                    ),
                    const Spacer(),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      color: Colors.blueAccent,
                      text: game.placeName,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Duration Info
                Row(
                  children: [
                    _buildInfoRow(
                      icon: Icons.access_time,
                      color: Colors.purple,
                      text: game.formattedDuration,
                    ),
                    const Spacer(),
                    if (game.isOngoing)
                      _buildInfoRow(
                        icon: Icons.circle,
                        color: Colors.red,
                        text: 'Live'.tr,
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Services Section (Goalkeeper, Referee & Water)
                if (game.goalkeeperAvailability || game.refereeAvailability || game.waterAvailability) ...[
                  _buildServicesSection(),
                  const SizedBox(height: 16),
                ],

                // Characteristics Section
                _buildDetailSection(
                  title: 'Venue Features'.tr,
                  items: game.characteristics ?? [],
                ),
              ],
            ),
          ),

          // Footer
          GestureDetector(
            onTap: () {
              Get.toNamed('/games?id=${game.id}');
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Get.isDarkMode
                        ? AppConst.darkBorderColor
                        : AppConst.lightBorderColor,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'View Details'.tr,
                  style: TextStyle(
                    color: AppConst.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppConst.darkCardColor
            : AppConst.lightCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppConst.darkBorderColor
              : AppConst.lightBorderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Services'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Get.isDarkMode
                  ? AppConst.darkTextSecondaryColor
                  : AppConst.lightTextSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (game.goalkeeperAvailability)
                _buildServiceChip(
                  '🥅 ${'Goalkeeper'.tr}',
                  Colors.blue,
                ),
              if (game.refereeAvailability)
                _buildServiceChip(
                  '👨‍⚖️ ${'Referee'.tr}',
                  Colors.orange,
                ),
              if (game.waterAvailability)
                _buildServiceChip(
                  '💧 ${'Water'.tr}',
                  Colors.cyan,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Get.isDarkMode
          ? AppConst.darkSurfaceColor
          : AppConst.lightSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Get.isDarkMode
              ? AppConst.darkBorderColor
              : AppConst.lightBorderColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getCharacteristicDisplayName(String characteristic) {
    // Try to use GameCharacteristic enum
    try {
      final gameChar = GameCharacteristic.fromString(characteristic);
      return gameChar.displayName;
    } catch (e) {
      // If not found in enum, return the original with translation
      return characteristic.tr;
    }
  }

  Widget _buildTeamBadge(String teamName, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        teamName,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMissingPlayers({required int missingPlayers, required Color color}) {
    return Text(
      missingPlayers > 0 ? '${'Missing'.tr}: $missingPlayers' : 'Full Team'.tr,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: color ?? AppConst.secondaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ${'QAR'.tr}';
  }

  Color _getStatusColor(GameModel game) {
    if (game.isOngoing) {
      return Colors.red; // Live match
    } else if (game.isUpcoming) {
      return Colors.orange; // Upcoming match
    } else {
      return Colors.green; // Finished match
    }
  }

  IconData _getStatusIcon(GameModel game) {
    if (game.isOngoing) {
      return Icons.circle; // Live indicator
    } else if (game.isUpcoming) {
      return Icons.pending;
    } else {
      return Icons.check_circle;
    }
  }

  Widget _buildDetailSection({
    required String title,
    required List<String> items,
  }) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppConst.darkCardColor
            : AppConst.lightCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppConst.darkBorderColor
              : AppConst.lightBorderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Get.isDarkMode
                  ? AppConst.darkTextSecondaryColor
                  : AppConst.lightTextSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: items.map((item) {
              return Chip(
                label: Text(
                  _getCharacteristicDisplayName(item),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Get.isDarkMode
                    ? AppConst.darkSurfaceColor
                    : AppConst.lightSurfaceColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Get.isDarkMode
                        ? AppConst.darkBorderColor
                        : AppConst.lightBorderColor,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}


class GamePlaceholder extends StatelessWidget {
  const GamePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final shimmerColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final shimmerColorLight = isDark ? Colors.grey[600] : Colors.grey[100];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppConst.darkCardColor : AppConst.lightCardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header placeholder
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 80,
                  height: 16,
                  color: shimmerColor,
                ),
                const Spacer(),
                Container(
                  width: 100,
                  height: 16,
                  color: shimmerColor,
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 16,
                  color: shimmerColor,
                ),
              ],
            ),
          ),

          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Teams placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 14,
                          color: shimmerColor,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 30,
                      height: 18,
                      color: shimmerColor,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 30,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 14,
                          color: shimmerColor,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Game Info placeholder
                Row(
                  children: [
                    Container(
                      width: 120,
                      height: 18,
                      color: shimmerColor,
                    ),
                    const Spacer(),
                    Container(
                      width: 120,
                      height: 18,
                      color: shimmerColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Services placeholder
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: shimmerColorLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppConst.darkBorderColor
                          : AppConst.lightBorderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Characteristics placeholder
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: shimmerColorLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppConst.darkBorderColor
                          : AppConst.lightBorderColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer placeholder
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? AppConst.darkBorderColor
                      : AppConst.lightBorderColor,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                width: 100,
                height: 16,
                color: shimmerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}