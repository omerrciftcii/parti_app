import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/screens/landing_screen.dart';

class EntranceScreen extends StatelessWidget {
  const EntranceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFF9ED),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LandingScreen(index: 1),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: (MediaQuery.of(context).size.height) / 2,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/club_party.png"),
                        )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'CLUB PARTY',
                        style: GoogleFonts.jost(
                            fontSize: 40, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LandingScreen(index: 0),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/home_party.png"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'HOME PARTY',
                        style: GoogleFonts.jost(
                            fontSize: 40, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
