import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/screens/login_screen.dart';
import 'package:parti_app/screens/register_with_email_screen.dart';
import 'package:parti_app/widgets/social_media_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Icon(
        //     Icons.arrow_back_outlined,
        //     color: Colors.black,
        //   ),
        // ),
        backgroundColor: Colors.white,
        title: Text(
          'Sign up!',
          style: GoogleFonts.ubuntu(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 12),
            child: SocialMediaButton(
              backgroundColor: Colors.blue[700],
              text: 'Continue with Facebook',
              textStyle: GoogleFonts.ubuntu(
                  color: Colors.white, fontWeight: FontWeight.bold),
              icon: const FaIcon(
                FontAwesomeIcons.facebookF,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Text(
            'You can sign in with facebook',
            style: GoogleFonts.ubuntu(color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'OR',
            style: GoogleFonts.ubuntu(color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18, bottom: 12, top: 20),
            child: SocialMediaButton(
              backgroundColor: Colors.transparent,
              text: 'Continue with Google',
              textStyle: GoogleFonts.ubuntu(
                  color: Colors.black, fontWeight: FontWeight.bold),
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterWithEmailScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 12),
              child: SocialMediaButton(
                backgroundColor: Colors.transparent,
                text: 'Continue with Email',
                textStyle: GoogleFonts.ubuntu(
                    color: Colors.black, fontWeight: FontWeight.bold),
                icon: const FaIcon(
                  Icons.email_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 12),
            child: RichText(
              text: TextSpan(
                text: 'Already have an account?',
                style: GoogleFonts.ubuntu(color: Colors.grey, fontSize: 12),
                children: [
                  TextSpan(
                    text: ' Sign in',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
