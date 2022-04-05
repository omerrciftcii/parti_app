import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  late AnimationController controller;
  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(milliseconds: 300);
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(
      context,
    );
    var userProvider = Provider.of<UserProvider>(
      context,
    );
    var homeProvider = Provider.of<HomeProvider>(
      context,
    );
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffFDFFE5),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Profile',
              style: GoogleFonts.jost(),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            actions: [Icon(Icons.psychology_outlined)],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await authProvider.signOut();
              if (result) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            child: Icon(Icons.exit_to_app),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child:
                                Stack(fit: StackFit.loose, children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(authProvider
                                                    .currentUser!
                                                    .profilePicture ==
                                                null
                                            ? "https://cdn1.vectorstock.com/i/1000x1000/82/55/anonymous-user-circle-icon-vector-18958255.jpg"
                                            : authProvider.currentUser!
                                                    .profilePicture ??
                                                'https://cdn1.vectorstock.com/i/1000x1000/82/55/anonymous-user-circle-icon-vector-18958255.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 105.0, right: 120.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          await showModalBottomSheet(
                                            transitionAnimationController:
                                                controller,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AnimatedContainer(
                                                duration: Duration(seconds: 10),
                                                height: 200,
                                                width: 400,
                                                child: Column(children: [
                                                  ListTile(
                                                    title: Text(
                                                        'Take your picture'),
                                                    onTap: () async {
                                                      authProvider.currentUser =
                                                          await userProvider
                                                              .changeProfilePicture(
                                                                  authProvider
                                                                      .currentUser!
                                                                      .userId,
                                                                  authProvider
                                                                      .currentUser,
                                                                  true);

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                        'Take from gallery'),
                                                    onTap: () async {
                                                      authProvider.currentUser =
                                                          await userProvider
                                                              .changeProfilePicture(
                                                                  authProvider
                                                                      .currentUser!
                                                                      .userId,
                                                                  authProvider
                                                                      .currentUser,
                                                                  false);

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ]),
                                              );
                                            },
                                          );
                                          // await userProvider
                                          //     .changeProfilePicture();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 20.0,
                                          child: Icon(
                                            Icons.add_a_photo_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          ),
                          Text(
                            authProvider.currentUser!.name,
                            style: GoogleFonts.jost(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mode_of_travel_outlined,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                homeProvider.addressTitle,
                                style: GoogleFonts.jost(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mark_as_unread_outlined,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                authProvider.currentUser!.email,
                                style: GoogleFonts.jost(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
