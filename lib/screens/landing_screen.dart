import 'package:flutter/material.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/screens/init_screen.dart';
import 'package:parti_app/screens/login_screen.dart';
import 'package:parti_app/screens/splash_screen.dart';
import 'package:parti_app/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../widgets/waiting_indicator.dart';
import 'entrance_screen.dart';
import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  final int index;
  LandingScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.uninitialized:
        return SplashScreen();
      case Status.unauthenticated:
        return InitScreen(
          index: index,
        );
      case Status.authenticating:
        return Center(
          child: CustomWaitingIndicator(),
        );
      case Status.authenticated:
        return BottomNavigationBarWidget(
          index: index,
        );

      default:
        return InitScreen(
          index: index,
        );
    }
  }
}
