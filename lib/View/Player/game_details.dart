import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qplay/Helper/game_characteristics.dart';
import 'package:qplay/ViewModel/payment_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../ViewModel/settings_view_model.dart';
import '../../../../Model/game_model.dart';
import '../../Model/team_model.dart';
import '../../ViewModel/game_view_model.dart';
import '../Widgets/game_details_placeholder.dart';

/// Displays the full details of a single [GameModel] identified by the
/// `id` query parameter in the route.
///
/// Shows:
/// * Match date, time, duration, type, price, and location (with a link to
///   open the map URL).
/// * Team rosters (Red / Blue) and missing-players count.
/// * Available amenities and venue characteristics.
/// * A **Join** button that calls [GameViewModel.joinGame] and then triggers
///   the payment flow via [PaymentViewModel.createPayment].
///
/// A placeholder skeleton ([GameDetailsPlaceholder]) is rendered while the
/// game data is loading.
class GameDetails extends StatefulWidget {
  const GameDetails({super.key});

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  final SettingsViewModel settingsViewModel = Get.find<SettingsViewModel>();
  final GameViewModel gameViewModel = Get.find<GameViewModel>();
  final PaymentViewModel paymentViewModel = Get.put(PaymentViewModel());

  late GameModel game;
  bool loading = true;
  late bool isExist;
  String? selectedTeam;

  @override
  void initState() {
    super.initState();
    gameViewModel.getGame(int.tryParse(Get.parameters['id'] ?? '') ?? 0).then((e) {
      if (e != null) {
        isExist = true;
        game = e;
      } else {
        isExist = false;
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (loading) {
              return GameDetailsPlaceholder();
            } else if (isExist) {
              return CustomScrollView(
                slivers: [
                  // Content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section
                        _buildHeroSection(),

                        // Quick Stats
                        _buildQuickStats(),

                        // Match Details
                        _buildMatchDetails(),

                        // Services (if available)
                        if (game.goalkeeperAvailability || game.refereeAvailability || game.waterAvailability)
                          _buildServicesSection(),

                        // Venue Features (if available)
                        if (game.characteristics != null && game.characteristics!.isNotEmpty)
                          _buildVenueFeatures(),

                        // Location
                        _buildLocationSection(),

                        // Teams (if available)
                        if (game.teams != null && game.teams!.length >= 2)
                          _buildTeamsSection(),

                        // Description (if available)
                        if (game.description != null && game.description!.isNotEmpty)
                          _buildDescriptionSection(),

                        const SizedBox(height: 10), // Space for join button
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return _buildNotFoundState();
            }
          },
        ),
      ),
      bottomNavigationBar: !loading && isExist ? _buildJoinButton() : null,
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(game),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              game.isOngoing
                  ? 'LIVE'.tr
                  : (game.isUpcoming ? 'UPCOMING'.tr : 'FINISHED'.tr),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            'Match Details'.tr,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Date & Time
          Text(
            _formatDateTime(game.matchDate),
            style: TextStyle(
              fontSize: 16,
              color: Get.isDarkMode ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 24),

          // Price
          Row(
            children: [
              Text(
                _formatPrice(game.price),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'per person'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode ? Colors.white60 : Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              label: 'Players',
              value: '${game.totalPlayers}',
              icon: Icons.group_outlined,
            ),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: _buildStatItem(
              label: 'Type',
              value: game.gameType.tr,
              icon: Icons.sports_soccer_outlined,
            ),
          ),
          SizedBox(width: 5,),
          Expanded(
            child: _buildStatItem(
              label: 'Duration',
              value: game.formattedDuration,
              icon: Icons.access_time_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: Get.isDarkMode ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label.tr,
              style: TextStyle(
                fontSize: 12,
                color: Get.isDarkMode ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchDetails() {
    return _buildSection(
      title: 'Match Information',
      child: Column(
        children: [
          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date & Time',
            value: intl.DateFormat('MMM dd, yyyy • HH:mm')
                .format(DateTime.parse(game.matchDate)),
          ),
          _buildDetailRow(
            icon: Icons.access_time_outlined,
            label: 'Duration',
            value: game.formattedDuration,
          ),
          _buildDetailRow(
            icon: Icons.sports_outlined,
            label: 'Match Type',
            value: game.gameType,
          ),
          _buildDetailRow(
            icon: Icons.attach_money_outlined,
            label: 'Price',
            value: _formatPrice(game.price),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildSection(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  game.placeName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _launchMap,
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text('View on Map'.tr),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                  color: Get.isDarkMode ? Colors.white24 : Colors.black12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return _buildSection(
      title: 'Available Services',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          if (game.goalkeeperAvailability)
            _buildServiceTag('🥅 ${'Goalkeeper'.tr}'),
          if (game.refereeAvailability)
            _buildServiceTag('👨‍⚖️ ${'Referee'.tr}'),
          if (game.waterAvailability)
            _buildServiceTag('💧 ${'Water'.tr}'),
        ],
      ),
    );
  }

  Widget _buildServiceTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Get.isDarkMode ? Colors.white70 : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTeamsSection() {
    return _buildSection(
      title: 'Teams',
      child: Row(
        children: [
          Expanded(
            child: _buildTeamCard(game.teams![0], Colors.red),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Text(
                'VS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Get.isDarkMode ? Colors.white60 : Colors.black54,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTeamCard(game.teams![1], Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(TeamModel team, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Team Icon
          Icon(
            Icons.group,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),

          // Team Name
          Text(
            team.name.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Missing Players Count
          Text(
            '${team.missingPlayers}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),

          Text(
            'Missing'.tr,
            style: TextStyle(
              fontSize: 12,
              color: Get.isDarkMode ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueFeatures() {
    return _buildSection(
      title: 'Venue Features',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: game.characteristics!.map((characteristic) {
          return _buildFeatureTag(_getCharacteristicDisplayName(characteristic));
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Get.isDarkMode ? Colors.white70 : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Description',
      child: Text(
        game.description!,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Get.isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Get.isDarkMode ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label.tr,
              style: TextStyle(
                fontSize: 15,
                color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    return Container(
      padding: !game.isEnrolled ? const EdgeInsets.all(24) : null,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Obx(() => ElevatedButton(
            onPressed: game.isEnrolled || paymentViewModel.isLoading.value
                ? null
                : _joinGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: game.isEnrolled
                  ? (Get.isDarkMode ? Colors.white24 : Colors.black12)
                  : (Get.isDarkMode ? Colors.white : Colors.black87),
              foregroundColor: game.isEnrolled
                  ? (Get.isDarkMode ? Colors.white60 : Colors.black54)
                  : (Get.isDarkMode ? Colors.black87 : Colors.white),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: paymentViewModel.isLoading.value
                ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Get.isDarkMode ? Colors.black87 : Colors.white,
              ),
            )
                : Text(
              game.isEnrolled ? 'Already Enrolled'.tr : 'Join Match'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          )),
        ),
      ),
    );
  }

  void _joinGame() {
    // Show team selection bottom sheet
    _showTeamSelectionBottomSheet();
  }

  void _showTeamSelectionBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Select Team'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Choose which team you want to join'.tr,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),

            const SizedBox(height: 24),

            // Teams in Row
            Row(
              children: [
                if (game.teams != null && game.teams!.length >= 2) ...[
                  Expanded(
                    child: _buildTeamSelectionCard(game.teams![0], const Color(0xFF007AFF)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTeamSelectionCard(game.teams![1], const Color(0xFFFF3B30)),
                  ),
                ] else ...[
                  // Fallback if teams data is not available
                  Expanded(
                    child: _buildSimpleTeamOption('Blue', const Color(0xFF007AFF)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSimpleTeamOption('Red', const Color(0xFFFF3B30)),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: Get.isDarkMode ? Colors.white24 : Colors.black12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Get.isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ),
            ),

            // Safe area padding
            SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildTeamSelectionCard(TeamModel team, Color accentColor) {
    return GestureDetector(
      onTap: () {
        Get.back();
        _selectTeam(team.name);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Team Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.group,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            // Team Name
            Text(
              team.name.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Missing Players
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    size: 14,
                    color: accentColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${team.missingPlayers}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            Text(
              team.missingPlayers > 0 ? 'Spots Available'.tr : 'Team Full'.tr,
              style: TextStyle(
                fontSize: 12,
                color: Get.isDarkMode ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTeamOption(String teamName, Color accentColor) {
    return GestureDetector(
      onTap: () {
        Get.back();
        _selectTeam(teamName);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Team Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.group,
                color: Colors.white,
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            // Team Name
            Text(
              teamName.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Join Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Join Team'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTeam(String teamName) {
    setState(() {
      selectedTeam = teamName;
    });

    // Start payment process
    gameViewModel.joinGame(
      gameId: game.id,
      team: teamName,
    ).then((e){
      if(e != null){
        setState(() {
          game = e;
        });
      }
    });
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_soccer_outlined,
              size: 80,
              color: Get.isDarkMode ? Colors.white24 : Colors.black26,
            ),
            const SizedBox(height: 24),
            Text(
              'No match found'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The match has been deleted or cancelled'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => Get.back(),
              child: Text('Go Back'.tr),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchMap() async {
    String? mapUrl;

    if (game.placeLatitude != null && game.placeLongitude != null) {
      mapUrl = "https://www.google.com/maps/search/?api=1&query=${game.placeLatitude},${game.placeLongitude}";
    } else if (game.mapUrl != null && game.mapUrl!.isNotEmpty) {
      mapUrl = game.mapUrl!;
    }

    if (mapUrl != null) {
      await launchUrl(
        Uri.parse(mapUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  String _getCharacteristicDisplayName(String characteristic) {
    try {
      final gameChar = GameCharacteristic.fromString(characteristic);
      return gameChar.displayName;
    } catch (e) {
      return characteristic.tr;
    }
  }

  Color _getStatusColor(GameModel game) {
    if (game.isOngoing) {
      return Colors.red; // Live match
    } else if (game.isUpcoming) {
      return const Color(0xFF007AFF); // Upcoming match
    } else {
      return const Color(0xFF34C759); // Finished match
    }
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(2)} ${'QAR'.tr}';
  }

  String _formatDateTime(String dateTimeString) {
    try {
      if(Get.locale!.languageCode == 'ar'){
        final dateTime = DateTime.parse(dateTimeString);
        final formatter = intl.DateFormat('MMM dd, yyyy • HH:mm');
        String formattedDate = formatter.format(dateTime);

        final weekdayFormatter = intl.DateFormat('EEEE');
        String englishWeekday = weekdayFormatter.format(dateTime);

        String arabicWeekday = englishWeekday.tr;

        return '$arabicWeekday, $formattedDate';
      }
      else{
        final dateTime = DateTime.parse(dateTimeString);
        return intl.DateFormat('EEEE, MMM dd, yyyy • HH:mm').format(dateTime);
      }

    } catch (e) {
      return dateTimeString;
    }
  }

}