import 'package:flutter/material.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/screens/init_screen.dart';
import 'package:parti_app/screens/login_screen.dart';
import 'package:parti_app/screens/splash_screen.dart';
import 'package:parti_app/widgets/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.uninitialized:
        return SplashScreen();
      case Status.unauthenticated:
        return InitScreen();
      case Status.authenticating:
        return Center(
          child: CircularProgressIndicator(),
        );
      case Status.authenticated:
        return BottomNavigationBarWidget();

      default:
        return InitScreen();
    }
  }
}
