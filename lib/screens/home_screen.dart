import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/styles/text_style.dart';
import 'package:parti_app/utils/search_delegate.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../widgets/event_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      homeProvider.initializeSettings();
      authProvider.getCurrentUser();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(
      context,
    );
    var homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: homeProvider.isWaiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        homeProvider.addressTitle,
                        style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: SearchLocations(),
                          );
                        },
                        child: Icon(Icons.location_on_outlined),
                      ),
                    ],
                  ),
                  // Card(
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width / 1.1,
                  //     height: 200,
                  //     color: Colors.white,
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //           height: 50,
                  //           width: double.infinity,
                  //           decoration: BoxDecoration(
                  //             border: Border.all(
                  //               color: Colors.grey[200] ?? Colors.black,
                  //             ),
                  //           ),
                  //           child: Center(
                  //             child: Text('Starting soon'),
                  //           ),
                  //         ),
                  //         Row(
                  //           children: [
                  //             Expanded(
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                     color: Colors.grey[200] ?? Colors.black,
                  //                   ),
                  //                 ),
                  //                 child: Center(
                  //                   child: Text('Today'),
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                     color: Colors.grey[200] ?? Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           children: [
                  //             Expanded(
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                     color: Colors.grey[200] ?? Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                     color: Colors.grey[200] ?? Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           children: [
                  //             Expanded(
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                     color: Colors.grey[200] ?? Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Container(
                  //                 height: 50,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                     color: Colors.grey[200] ?? Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Text(
                    "UPCOMING EVENTS NEARBY",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  NearbyEventCard(
                    onTap: () {},
                    image: image1,
                    location: "Kadikoy/Istanbul",
                    title: "Dudes Party",
                  ),
                  NearbyEventCard(
                    onTap: () {},
                    image: image2,
                    location: "Kadikoy/Istanbul",
                    title: "Kadikoy",
                  ),
                ],
              ),
            ),
    );
  }
}
