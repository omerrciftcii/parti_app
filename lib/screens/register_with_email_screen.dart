import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/providers/auth_provider.dart';
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
      body: Column(
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
              controller: authProvider.registerNameController,
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
              isSecureText: authProvider.isTextVisible,
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
            subtitle: Text('Not set'),
            onTap: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (content) {
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.white54,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ageList.map((e) {
                            return TextButton(
                              onPressed: () {},
                              child: Text(
                                e.toString(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  });
            },
          ),
          ListTile(
            title: Text('Gender'),
            subtitle: Text('Not set'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18),
            child: CustomButton(
              backgroundColor: Colors.cyan,
              text: 'Sign up',
              textStyle: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
