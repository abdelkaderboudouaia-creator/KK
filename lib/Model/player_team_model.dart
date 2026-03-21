

import 'package:qplay/Model/player_model.dart';
import 'package:qplay/Model/team_model.dart';

/// Pivot / join-table model that records which [PlayerModel] belongs to which
/// [TeamModel] within a game.
///
/// When a player joins a game the backend creates a [PlayerTeamModel] row
/// linking [playerId] ↔ [teamId].  This list is returned inside
/// [TeamModel.playerTeams] so the UI can display team rosters.
class PlayerTeamModel {
  final int id;
  final int playerId;
  final int teamId;
  final String createdAt;
  final String updatedAt;
  final PlayerModel? player;
  final TeamModel? team;

  PlayerTeamModel({
    required this.id,
    required this.playerId,
    required this.teamId,
    required this.createdAt,
    required this.updatedAt,
    this.player,
    this.team,
  });

  factory PlayerTeamModel.fromJson(Map<String, dynamic> json) {
    return PlayerTeamModel(
      id: json['id'] ?? 0,
      playerId: json['player_id'] ?? 0,
      teamId: json['team_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      player: json['player'] != null ? PlayerModel.fromJson(json['player']) : null,
      team: json['team'] != null ? TeamModel.fromJson(json['team']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'team_id': teamId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'player': player?.toJson(),
      'team': team?.toJson(),
    };
  }
}