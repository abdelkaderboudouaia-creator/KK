

import 'package:qplay/Model/game_model.dart';
import 'package:qplay/Model/player_model.dart';
import 'package:qplay/Model/player_team_model.dart';

/// Represents one of the two competing teams in a [GameModel].
///
/// Each game is split into exactly two teams: **Red** and **Blue** (see
/// [isRed] / [isBlue]).  A team holds a list of [PlayerTeamModel] entries
/// ([playerTeams]) that map enrolled players to this team.
///
/// [missingPlayers] tells the UI how many spots are still open, so the
/// join-game button can be shown or hidden accordingly.
class TeamModel {
  final int id;
  final int? gameId;
  final String name; // 'Red' or 'Blue'
  final String gameType; // 'Football' or 'Paddle'
  final String createdAt;
  final String updatedAt;
  final GameModel? game;
  final List<PlayerTeamModel>? playerTeams;
  final int missingPlayers;

  TeamModel({
    required this.id,
    this.gameId,
    required this.name,
    required this.gameType,
    required this.createdAt,
    required this.updatedAt,
    required this.missingPlayers,
    this.game,
    this.playerTeams,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? 0,
      gameId: json['game_id'],
      name: json['name'] ?? '',
      gameType: json['game'] ?? 'Football',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      missingPlayers: json['missing_players'] ?? 0,
      game: json['game_model'] != null ? GameModel.fromJson(json['game_model']) : null,
      playerTeams: json['player_teams'] != null
          ? (json['player_teams'] as List).map((pt) => PlayerTeamModel.fromJson(pt)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'name': name,
      'game': gameType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'game_model': game?.toJson(),
      'player_teams': playerTeams?.map((pt) => pt.toJson()).toList(),
    };
  }

  bool get isRed => name == 'Red';
  bool get isBlue => name == 'Blue';
  int get playersCount => playerTeams?.length ?? 0;

  List<PlayerModel> get players => playerTeams?.map((pt) => pt.player).where((p) => p != null).cast<PlayerModel>().toList() ?? [];
}