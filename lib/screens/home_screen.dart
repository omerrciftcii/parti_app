import 'package:flutter/material.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/screens/init_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeProvider.getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(
      context,
    );
    var homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        var result = await authProvider.signOut();
        if (result) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }),
      body: Center(
        child: Text(
            'Welcome, your current address is: ${homeProvider.addressTitle}'),
      ),
    );
  }
}
