import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qplay/ViewModel/Api/Exceptions/api_exception.dart';

import '../../Helper/app_const.dart';

/// Low-level HTTP client for game-related endpoints.
///
/// | Method     | HTTP | Endpoint          |
/// |------------|------|-------------------|
/// | [getGames] | GET  | `/games`          |
/// | [getGame]  | GET  | `/games/:id`      |
/// | [joinGame] | POST | `/join-game`      |
///
/// [getGames] throws an [ApiException] on non-200 responses so the
/// [GameViewModel] can surface meaningful error messages.
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
