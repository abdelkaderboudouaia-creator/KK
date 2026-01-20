import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../Helper/app_const.dart';
import '../../ViewModel/notification_view_model.dart';
import '../../ViewModel/settings_view_model.dart';
import 'Tabs/notifications.dart';
import 'Tabs/home.dart';
import 'Tabs/profile.dart';
import 'package:badges/badges.dart' as badges;


class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key,this.route = '/home'});
  final String route;

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen>{
  final SettingsViewModel settingsViewModel = Get.find<SettingsViewModel>();

  int selectedIndex = 0;

  final iconList = <IconData>[
    CupertinoIcons.home,
    CupertinoIcons.bell,
    CupertinoIcons.person,
  ];

  final textList = <String>[
    'Home',
    'Notifications',
    'Profile',
  ];

  List<Widget> tabs = [
    const Home(),
    const Notifications(),
    const Profile(),
  ];

  List<Map<String,Widget>> routes = [
    {
      '/home' : const Home()
    },
    {
      '/notifications' : const Notifications()
    },
    {
      '/profile' : const Profile()
    },
  ];


  @override
  void initState() {
    super.initState();
    selectedIndex = routes.indexWhere((e)=> e.keys.toList().first == widget.route);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () { return Future.value(false); },
      child: GetBuilder<SettingsViewModel>(
          builder: (_) {
            return Scaffold(
              body: routes[selectedIndex].values.toList()[0],
              bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                leftCornerRadius: 15,
                rightCornerRadius: 15,
                splashSpeedInMilliseconds: 0,
                elevation: 20,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                activeIndex: routes.indexWhere((e)=> e.keys.toList().first == settingsViewModel.selectedRoute),
                gapLocation: GapLocation.none,
                notchSmoothness: NotchSmoothness.defaultEdge,
                onTap: (i) {
                  settingsViewModel.setSelectedRoute = routes[i].keys.toList().first;
                },
                itemCount: 3,
                tabBuilder: (int index, bool isActive) {
                  final textColor = isActive
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyMedium!.color;
                  if(textList[index] == 'Notifications'){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(()=>badges.Badge(
                          position: badges.BadgePosition.topEnd(top: -6, end: 4),
                          badgeStyle: const badges.BadgeStyle(badgeColor: Colors.transparent),
                          badgeAnimation: const badges.BadgeAnimation.fade(animationDuration: Duration.zero),
                          badgeContent: !Get.find<NotificationViewModel>().allRead.value ? Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ) : null,
                          child: Icon(
                              iconList[index],
                              color: textColor
                          ),
                        )),
                        Text(
                          textList[index].tr,
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconList[index],
                        color: textColor,
                      ),
                      Text(
                        textList[index].tr,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
      ),
    );
  }
}


