import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/constants/constants.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/screens/home_screen.dart';
import 'package:parti_app/widgets/bottom_navigation_bar.dart';
import 'package:parti_app/widgets/custom_button.dart';
import 'package:parti_app/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class RegisterWithEmailScreen extends StatelessWidget {
  RegisterWithEmailScreen({Key? key}) : super(key: key);
  var ageList = [for (var i = 18; i < 99; i += 1) i];
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
          'Sign up!',
          style: GoogleFonts.ubuntu(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Form(
        key: authProvider.registerFormKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 9),
              child: CustomTextField(
                  controller: authProvider.registerNameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter your name';
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 9),
              child: CustomTextField(
                  controller: authProvider.registerEmailController,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == "") {
                      return 'Please enter your mail address';
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 9),
              child: CustomTextField(
                controller: authProvider.registerPasswordController,
                hintText: 'Password',
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your password';
                  } else if (value!.length < 6) {
                    return 'Password should be at least 6 character';
                  }
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
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 9),
              child: Text(
                'We will send informations to your mail address and you name will be visible to others',
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            ListTile(
              title: Text('Age'),
              subtitle: Text(authProvider.selectedAge != 0
                  ? authProvider.selectedAge.toString()
                  : 'Not Set'),
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Dialog(
                          child: Container(
                            width: 350,
                            height: 450,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: ageList.map((e) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                                0.25), // border color
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                2), // border width
                                            child: Container(
                                              // or ClipRRect if you need to clip the content
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: authProvider
                                                            .selectedAge ==
                                                        e
                                                    ? Colors.orange
                                                    : Colors
                                                        .white, // inner circle color
                                              ),
                                              child:
                                                  Container(), // inner content
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {});
                                          authProvider.selectedAge = e;
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          e.toString(),
                                          style: GoogleFonts.ubuntu(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      });
                    });
              },
            ),
            ListTile(
                title: Text('Gender'),
                subtitle: Text(authProvider.selectedGender != ""
                    ? authProvider.selectedGender
                    : 'Not set'),
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Dialog(
                            child: Container(
                              width: 350,
                              height: 200,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: Constants.genderList.map((e) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                  0.25), // border color
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  2), // border width
                                              child: Container(
                                                // or ClipRRect if you need to clip the content
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: authProvider
                                                              .selectedGender ==
                                                          e
                                                      ? Colors.orange
                                                      : Colors
                                                          .white, // inner circle color
                                                ),
                                                child:
                                                    Container(), // inner content
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {});
                                            authProvider.selectedGender = e;
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            e.toString(),
                                            style: GoogleFonts.ubuntu(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        });
                      });
                }),
            authProvider.status == Status.authenticating
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () async {
                      try {
                        var result = await authProvider.signUpWithEmail();
                        if (result) {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomNavigationBarWidget(),
                            ),
                          );
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
                      padding: EdgeInsets.only(left: 18.0, right: 18),
                      child: CustomButton(
                        backgroundColor: Colors.cyan,
                        text: 'Sign up',
                        textStyle: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
