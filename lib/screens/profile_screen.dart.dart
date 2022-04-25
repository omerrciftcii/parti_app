import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/providers/user_provider.dart';
import 'package:parti_app/screens/my_events_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/waiting_indicator.dart';

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
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: Colors.black,
                ),
                Text(
                  'Profile',
                  style: GoogleFonts.jost(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            shape: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            actions: [
              Icon(
                Icons.psychology_outlined,
                color: Colors.black,
                size: 24,
              )
            ],
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
                                  // ClipOval(
                                  //   child: authProvider
                                  //               .currentUser!.profilePicture ==
                                  //           null
                                  //       ? SvgPicture.asset(
                                  //           'assets/images/bowl.svg')
                                  //       : CachedNetworkImage(
                                  //           imageUrl: authProvider.currentUser!
                                  //                   .profilePicture ??
                                  //               '',
                                  //           height: 140,
                                  //           width: 140,
                                  //           fit: BoxFit.contain,
                                  //         ),
                                  // )
                                  CachedNetworkImage(
                                    imageUrl: authProvider
                                                .currentUser!.profilePicture ==
                                            null
                                        ? 'https://unsplash.com/photos/tpxnuebsy28'
                                        : 'https://upload.wikimedia.org/wikipedia/commons/6/6b/Lana_del_Rey.jpg',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 140.0,
                                      height: 140.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const CustomWaitingIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 105.0, right: 120.0),
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
                                                    title: const Text(
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
                                                    title: const Text(
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
                                        child: const CircleAvatar(
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
                              const Icon(Icons.mode_of_travel_outlined,
                                  color: Color(0xff787878)),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                homeProvider.addressTitle,
                                style: GoogleFonts.jost(
                                    color: Color(0xff787878), fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.mark_as_unread_outlined,
                                color: Color(0xff787878),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                authProvider.currentUser!.email,
                                style: GoogleFonts.jost(
                                    color: Color(0xff787878), fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            title: Text(
                              'My Events',
                              style: GoogleFonts.jost(),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MyCreatedEvents(),
                                ),
                              );
                            },
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
