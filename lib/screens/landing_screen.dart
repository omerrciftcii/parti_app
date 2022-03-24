import 'package:flutter/material.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case :
        
        break;
      default:
    }
  }
}
