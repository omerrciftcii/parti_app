import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parti_app/screens/home_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../screens/profile_screen.dart.dart';
import '../screens/explore_screen.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int index;
  BottomNavigationBarWidget({required this.index});
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.cottage_outlined),
        title: ("Home"),
        activeColorPrimary: Color(0xffD8A64D),
        inactiveColorPrimary: Color(0xff787878),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.travel_explore),
        title: ("Home"),
        activeColorPrimary: Color(0xffD8A64D),
        inactiveColorPrimary: Color(0xff787878),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings_accessibility),
        title: ("Profile"),
        activeColorPrimary: Color(0xffD8A64D),
        inactiveColorPrimary: Color(0xff787878),
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(
        index: index,
      ),
      ExploreScreen(),
      ProfilePage()
    ];
  }

  PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,

      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: false, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.simple, // Choose the nav bar style with this property.
    );
  }
}
