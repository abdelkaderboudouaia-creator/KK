import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qplay/Helper/app_routes.dart';
import 'package:qplay/Model/game_model.dart';
import 'package:qplay/ViewModel/Api/Exceptions/api_exception.dart';

import 'Api/game_api.dart';

class GameViewModel extends GetxController {

  bool isLoading = false;
  bool isCreating = false;

  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  GameApi gameApi = GameApi();

  List<GameModel> games = [];

  Future<void> getGames({bool showLoading = true,String? gameType}) async {
    if(showLoading){
      isLoading = true;
      update();
    }
    try {
      var r = await gameApi.getGames(gameType: gameType);
      if (r.statusCode == 200) {
        var json = jsonDecode(r.body) as List;
        games.assignAll(json.map((map) => GameModel.fromJson(map)).toList());
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.message.tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> createGame({
    required DateTime matchDate,
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
      isCreating = true;
      update();

      final response = await gameApi.createGame(
        matchDate: _dateFormat.format(matchDate),
        matchDuration: matchDuration,
        gameType: gameType,
        placeName: placeName,
        price: price,
        playersPerTeam: playersPerTeam,
        goalkeeperAvailability: goalkeeperAvailability,
        refereeAvailability: refereeAvailability,
        waterAvailability: waterAvailability,
        characteristics: characteristics,
        description: description,
        mapUrl: mapUrl,
        placeLongitude: placeLongitude,
        placeLatitude: placeLatitude,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success'.tr,
          'Game created successfully'.tr,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
        await getGames(showLoading: false);
        return true;
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Authentication Required'.tr,
          'Please log in to continue'.tr,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(Routes.LOGIN);
        });
      } else {
        String errorMessage = 'An error occurred, please try again later'.tr;
        try {
          final data = jsonDecode(response.body);
          if (data['message'] != null) {
            errorMessage = data['message'].toString().tr;
          } else if (data['errors'] != null) {
            final errors = data['errors'] as Map<String, dynamic>;
            errorMessage = errors.values
                .map((e) => (e as List).first.toString())
                .join('\n');
          }
        } catch (_) {}
        Get.snackbar(
          'Error'.tr,
          errorMessage,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'Error'.tr,
        e.message.tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Check your connectivity'.tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isCreating = false;
      update();
    }
    return false;
  }


  Future<GameModel?> getGame(int gameId) async {
    try {
      var r = await gameApi.getGame(gameId);
      if (r.statusCode == 200) {
        return GameModel.fromJson(jsonDecode(r.body));
      }
      if (r.statusCode == 500) {
        return await getGame(gameId);
      }
    } catch (e) {
      if (e.toString().contains('Network is unreachable') ||
          e.toString().contains('Failed host lookup') ||
          e.toString().contains('No route to host') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection failed') ||
          e.toString().contains('Connection refused')) {
        await Future.delayed(const Duration(seconds: 1));
        return await getGame(gameId);
      }
    }
    return null;
  }


  Future<GameModel?> joinGame({
    required int gameId,
    required String team,
  }) async {
    try {
      isLoading = true;

      final response = await gameApi.joinGame(
        gameId: gameId,
        team: team,
      );
      final data = jsonDecode(response.body);

      String message = data['message'] ?? '';

      if (response.statusCode == 200) {

        Get.snackbar(
            'Success'.tr,
            message.tr,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.green
        );


        return await getGame(gameId);

      } else if (response.statusCode == 400) {
        Get.snackbar(
            'Error'.tr,
            message.tr,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      } else if(response.statusCode == 401) {
        Get.snackbar(
          'Authentication Required'.tr,
          'Please log in to continue'.tr,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );

        Future.delayed(Duration(seconds: 1), () {
          Get.offAllNamed(Routes.LOGIN);
        });
      }
      else  {
        Get.snackbar(
            'Error'.tr,
            'An error occurred, please try again later'.tr,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.white,
            backgroundColor: Colors.red
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error'.tr,
        'Check your connectivity'.tr,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading = false;
    }
  }

}
