import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/providers/user_provider.dart';
import 'package:parti_app/screens/landing_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(
        const AssetImage("assets/images/parti_app_background.jpg"), context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider.instance()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}
