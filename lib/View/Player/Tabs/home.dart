import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/View/Player/Widgets/custom_categories_game.dart';

import '../../../Helper/app_const.dart';
import '../../../ViewModel/game_view_model.dart';
import '../../../ViewModel/settings_view_model.dart';
import '../../Widgets/custom_game.dart';

/// Home tab – displays the list of available upcoming games.
///
/// Loads games via [GameViewModel.getGames] on first render.  Games can be
/// filtered by category (Football / Padel) using [CustomCategoriesGame].
/// Each game is rendered by [CustomGame].  Pull-to-refresh reloads the list.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GameViewModel gameViewModel = Get.find<GameViewModel>();

  @override
  void initState() {
    super.initState();
    if(gameViewModel.games.isEmpty){
      gameViewModel.getGames();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        title: Text(
          'Home'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
        child: GetBuilder<GameViewModel>(
          builder: (controller) {
            if(controller.isLoading){
              return Column(
                children: [
                  const SizedBox(height: 5,),
                  CategoriesPlaceholder(),
                  const SizedBox(height: 5,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GamePlaceholder();
                      },
                    ),
                  ),
                ],
              );
            }
            else if(!controller.isLoading && controller.games.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5,),
                    CustomCategoriesGame(
                      categories: ['All' ,  'Football' , 'Padel'],
                      onSelect: (index) {
                        final categories =  ['All' ,  'Football' , 'Padel'];
                        if(index > 0){
                          gameViewModel.getGames(gameType: categories[index],showLoading: false);
                        }
                        else{
                          gameViewModel.getGames(showLoading: false);
                        }
                        print("Selected category: ${index}");
                      },
                    ),
                    const SizedBox(height: 220),
                    Image.asset('assets/images/empty.png', width: 150),
                    Text(
                      'No matches at the moment'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }
            else{
              return Column(
                children: [
                  const SizedBox(height: 5,),
                  CustomCategoriesGame(
                    categories: ['All' ,  'Football' , 'Padel'],
                    onSelect: (index) {
                      final categories =  ['All' ,  'Football' , 'Padel'];
                      if(index > 0){
                        gameViewModel.getGames(gameType: categories[index],showLoading: false);
                      }
                      else{
                        gameViewModel.getGames(showLoading: false);
                      }
                      print("Selected category: ${index}");
                    },
                  ),
                  const SizedBox(height: 5,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.games.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final game  = controller.games[index];
                        return CustomGame(game: game);
                      },
                    ),
                  ),

                ],
              );
            }



          },
        ),
      ),
    );
  }
}