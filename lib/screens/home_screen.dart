import 'package:flutter/material.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(
      context,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        authProvider.signOut();
      }),
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
