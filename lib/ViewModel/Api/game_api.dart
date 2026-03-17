import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qplay/ViewModel/Api/Exceptions/api_exception.dart';

import '../../Helper/app_const.dart';

class GameApi {
  Future<http.Response> getGames({String? gameType}) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConst.endPoint}/games?game=$gameType'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        var json = jsonDecode(response.body);
        throw ApiException(
            message: json['message'], statusCode: response.statusCode);
      }
    } catch (e) {
      throw ApiException(message: 'Error Network', statusCode: 500);
    }
  }

  Future<http.Response> getGame(int gameId) async {
    return await http.get(
      Uri.parse('${AppConst.endPoint}/games/$gameId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'

      },
    );
  }

  Future<http.Response> createGame({
    required String matchDate,
    required int matchDuration,
    required String gameType,
    required String placeName,
    required double price,
    required int playersPerTeam,
    required bool goalkeeperAvailability,
    required bool refereeAvailability,
    required bool waterAvailability,
    List<String>? characteristics,
    String? description,
    String? mapUrl,
    double? placeLongitude,
    double? placeLatitude,
  }) async {
    try {
      return await http.post(
        Uri.parse('${AppConst.endPoint}/games'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${AppConst.prefs.getString('token')}',
        },
        body: jsonEncode({
          'match_date': matchDate,
          'match_duration': matchDuration,
          'game': gameType,
          'place_name': placeName,
          'price': price,
          'players_per_team': playersPerTeam,
          'goalkeeper_availability': goalkeeperAvailability,
          'referee_availability': refereeAvailability,
          'water_availability': waterAvailability,
          'characteristics': characteristics,
          'description': description,
          'map_url': mapUrl,
          'place_log': placeLongitude,
          'place_lat': placeLatitude,
        }),
      );
    } catch (e) {
      throw ApiException(message: 'Check your connectivity', statusCode: 500);
    }
  }

  Future<http.Response> joinGame({
    required int gameId,
    required String team,
    String? street,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    String? custom1,
  }) async {
    return await http.post(
      Uri.parse('${AppConst.endPoint}/join-game'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AppConst.prefs.getString('token')}',
      },
      body: jsonEncode({
        'game_id': gameId,
        'team': team,
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'postal_code': postalCode,
        'custom1': custom1,
      }),
    );
  }
}
