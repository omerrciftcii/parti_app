import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/screens/register_screen.dart';
import 'package:parti_app/widgets/custom_button.dart';
import 'package:parti_app/widgets/custom_textfield.dart';
import 'package:parti_app/widgets/social_media_button.dart';
import 'package:provider/provider.dart';

import '../widgets/waiting_indicator.dart';

class LoginScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
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
              height: 60,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  var isLoginSuccess = await authProvider.signInWithFacebook();
                  if (isLoginSuccess) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18, bottom: 24),
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
            ),
            GestureDetector(
              onTap: () async {
                try {
                  var isLoginSuccess = await authProvider.signInWithGoogle();
                  if (isLoginSuccess) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
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
              child: CustomTextField(
                controller: authProvider.emailController,
                hintText: 'Email',
                validator: (value) {
                  if (value == "") {
                    return 'Please enter valid email';
                  }
                  return null;
                },
                inputType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 9),
              child: CustomTextField(
                controller: authProvider.passwordController,
                hintText: 'Password',
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Password should be at least 6 character';
                  } else if (value == "") {
                    return 'Please enter password';
                  }
                  return null;
                },
                suffixIcon: authProvider.isTextVisible
                    ? const FaIcon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : const FaIcon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                suffixIconPressed: () {
                  authProvider.isTextVisible = true;
                },
                isSecureText: !authProvider.isTextVisible,
              ),
            ),
            authProvider.status == Status.authenticating
                ? const Center(child: CustomWaitingIndicator())
                : GestureDetector(
                    onTap: () async {
                      try {
                        await authProvider.signIn(
                          null,
                          null,
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
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
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                'Forgot password?',
                style: GoogleFonts.ubuntu(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18, bottom: 12, top: 18),
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: GoogleFonts.ubuntu(color: Colors.grey, fontSize: 12),
                  children: [
                    TextSpan(
                      text: ' Sign up',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.orange),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18, bottom: 12, top: 18),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "By continuing, you agree to Parti App's Terms of Service. We will manage information about you as described in our Privacy Policy and Cookie Policy",
                  style: GoogleFonts.ubuntu(color: Colors.grey, fontSize: 12),
                  children: [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
