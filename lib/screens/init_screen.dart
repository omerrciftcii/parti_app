import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/screens/login_screen.dart';
import 'package:parti_app/screens/register_screen.dart';

import '../widgets/custom_button.dart';
import 'home_screen.dart';

class InitScreen extends StatelessWidget {
  final int index;
  InitScreen({required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/parti_app_background.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18, bottom: 16),
                child: CustomButton(
                  backgroundColor: Colors.red[400],
                  text: 'Sign in',
                  textStyle: GoogleFonts.ubuntu(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterScreen(),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18, bottom: 24),
                child: CustomButton(
                  backgroundColor: Colors.grey[300],
                  text: 'Sign up',
                  textStyle: GoogleFonts.ubuntu(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(index: index),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Continue as guest',
                  style: GoogleFonts.ubuntu(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
