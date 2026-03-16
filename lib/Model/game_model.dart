



import 'package:qplay/Model/admin_model.dart';
import 'package:qplay/Model/payment_model.dart';
import 'package:qplay/Model/team_model.dart';

/// Represents a sports match (game) available on the QPlay platform.
///
/// Each game has a type ([gameType]: `Football` or `Padel`), a scheduled
/// [matchDate], a [price] per player, a [placeName] where it takes place,
/// and two teams ([TeamModel]): **Red** and **Blue** (accessible via
/// [redTeam] and [blueTeam]).
///
/// Useful computed properties:
/// * [isUpcoming] / [isPast] / [isOngoing] – timing helpers.
/// * [totalPlayers]          – total enrolled players across both teams.
/// * [formattedDuration]     – human-readable match length.
/// * [availableAmenities]    – list of provided services (goalkeeper, referee, water).
/// * [isEnrolled]            – whether the currently authenticated user is
///   already enrolled in this game.
class GameModel {
  final int id;
  final int? adminId;
  final String matchDate;
  final int matchDuration; // Duration in minutes
  final List<String>? characteristics;
  final bool goalkeeperAvailability;
  final bool refereeAvailability;
  final bool waterAvailability;
  final String gameType; // 'Football' or 'Paddle'
  final double? placeLongitude;
  final double? placeLatitude;
  final String placeName;
  final double price;
  final String? mapUrl;
  final String? description;
  final int playersPerTeam;
  final String createdAt;
  final String updatedAt;
  final AdminModel? admin;
  final List<TeamModel>? teams;
  final List<PaymentModel>? payments;
  final bool isEnrolled;

  GameModel({
    required this.id,
    this.adminId,
    required this.matchDate,
    required this.matchDuration,
    this.characteristics,
    required this.goalkeeperAvailability,
    required this.refereeAvailability,
    required this.waterAvailability,
    required this.gameType,
    this.placeLongitude,
    this.placeLatitude,
    required this.placeName,
    required this.price,
    this.description,
    required this.playersPerTeam,
    required this.createdAt,
    required this.updatedAt,
    this.admin,
    this.teams,
    this.payments,
    required this.isEnrolled,
    required this.mapUrl,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? 0,
      adminId: json['admin_id'],
      matchDate: json['match_date'] ?? '',
      matchDuration: json['match_duration'] ?? 90,
      characteristics: json['characteristics'] != null
          ? List<String>.from(json['characteristics'])
          : null,
      goalkeeperAvailability: json['goalkeeper_availability'] ?? false,
      refereeAvailability: json['referee_availability'] ?? false,
      waterAvailability: json['water_availability'] ?? false,
      gameType: json['game'] ?? 'Football',
      placeLongitude: json['place_log']?.toDouble(),
      placeLatitude: json['place_lat']?.toDouble(),
      placeName: json['place_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'],
      playersPerTeam: json['players_per_team'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      admin: json['admin'] != null ? AdminModel.fromJson(json['admin']) : null,
      teams: json['teams'] != null
          ? (json['teams'] as List).map((team) => TeamModel.fromJson(team)).toList()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List).map((payment) => PaymentModel.fromJson(payment)).toList()
          : null,
      isEnrolled: json['is_enrolled'] ?? false,
      mapUrl: json['map_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'match_date': matchDate,
      'match_duration': matchDuration,
      'characteristics': characteristics,
      'goalkeeper_availability': goalkeeperAvailability,
      'referee_availability': refereeAvailability,
      'water_availability': waterAvailability,
      'game': gameType,
      'place_log': placeLongitude,
      'place_lat': placeLatitude,
      'place_name': placeName,
      'price': price,
      'map_url': mapUrl,
      'description': description,
      'players_per_team': playersPerTeam,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'admin': admin?.toJson(),
      'teams': teams?.map((team) => team.toJson()).toList(),
      'payments': payments?.map((payment) => payment.toJson()).toList(),
      'is_enrolled': isEnrolled,
    };
  }

  bool get isFootball => gameType == 'Football';
  bool get isPadel => gameType == 'Padel';

  DateTime get matchDateTime => DateTime.parse(matchDate);
  bool get isUpcoming => matchDateTime.isAfter(DateTime.now());
  bool get isPast => matchDateTime.isBefore(DateTime.now());

  // Get match end time based on duration
  DateTime get matchEndDateTime => matchDateTime.add(Duration(minutes: matchDuration));

  // Check if match is currently ongoing
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(matchDateTime) && now.isBefore(matchEndDateTime);
  }

  // Format match duration as string (e.g., "1h 30m" or "90m")
  String get formattedDuration {
    if (matchDuration >= 60) {
      final hours = matchDuration ~/ 60;
      final minutes = matchDuration % 60;
      if (minutes == 0) {
        return "${hours}h";
      }
      return "${hours}h ${minutes}m";
    }
    return "${matchDuration}m";
  }

  int get totalPlayers => teams?.fold(0, (sum, team) => (sum ?? 0) + (team.playerTeams?.length ?? 0)) ?? 0;

  TeamModel? get redTeam => teams?.firstWhere(
          (team) => team.name == 'Red',
      orElse: () => TeamModel(
          id: 0,
          name: '',
          gameType: '',
          createdAt: '',
          updatedAt: '',
          missingPlayers: 0
      )
  );

  TeamModel? get blueTeam => teams?.firstWhere(
          (team) => team.name == 'Blue',
      orElse: () => TeamModel(
          id: 0,
          name: '',
          gameType: '',
          createdAt: '',
          updatedAt: '',
          missingPlayers: 0
      )
  );

  // Check if all amenities are available
  bool get hasAllAmenities => goalkeeperAvailability && refereeAvailability && waterAvailability;

  // Get list of available amenities
  List<String> get availableAmenities {
    List<String> amenities = [];
    if (goalkeeperAvailability) amenities.add('Goalkeeper');
    if (refereeAvailability) amenities.add('Referee');
    if (waterAvailability) amenities.add('Water');
    return amenities;
  }
}