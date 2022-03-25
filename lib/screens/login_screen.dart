import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/widgets/custom_button.dart';
import 'package:parti_app/widgets/social_media_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Welcome!',
          style: GoogleFonts.ubuntu(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Form(
        key: authProvider.loginFormKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 24),
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
            GestureDetector(
              onTap: () async {
                try {
                  await authProvider.signInWithGoogle();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    e.toString(),
                  )));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: SocialMediaButton(
                  backgroundColor: Colors.transparent,
                  text: 'Continue with Google',
                  textStyle: GoogleFonts.ubuntu(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: authProvider.emailController,
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Email" : null,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    hintText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 9),
              child: TextFormField(
                controller: authProvider.passwordController,
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Password" : null,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    hintText: 'Password'),
              ),
            ),
            authProvider.status == Status.authenticating
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () async {
                      try {
                        await authProvider.signIn();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          e.toString(),
                        )));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 18),
                      child: CustomButton(
                        backgroundColor: Colors.cyan,
                        text: 'Log in',
                        textStyle: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
