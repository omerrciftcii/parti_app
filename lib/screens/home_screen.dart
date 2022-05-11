import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/models/filter_model.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/home_provider.dart';
import 'package:parti_app/screens/event_list_screen.dart';
import 'package:provider/provider.dart';
import '../ui_helpers/expandable_fab.dart';
import 'new_event_screen.dart';

class HomeScreen extends StatefulWidget {
  final int index;

  const HomeScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    homeProvider.homeTabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: widget.index,
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      homeProvider.initializeSettings();
      authProvider.getCurrentUser();
    });
    super.initState();
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(''),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(
      context,
    );
    var homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 90.0,
        children: [
          ActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NewEventScreen(),
              ),
            ),
            icon: const Icon(
              Icons.person_add_alt_outlined,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(
              Icons.map,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TabBar(
                controller: homeProvider.homeTabController,
                tabs: [
                  Tab(
                    child: Text(
                      'Club Parties',
                      style: GoogleFonts.jost(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Home Parties',
                      style: GoogleFonts.jost(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: TabBarView(
                controller: homeProvider.homeTabController,
                children: [
                  Center(
                    child: EventListScreen(
                      filters: FilterModel(isHomeParty: true),
                    ),
                  ),
                  Center(
                    child: EventListScreen(
                        filters: FilterModel(isHomeParty: false)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: homeProvider.isWaiting
    //       ? Center(
    //           child: CustomWaitingIndicator(),
    //         )
    //       : Padding(
    //           padding: const EdgeInsets.only(left: 18, right: 18, top: 48),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     homeProvider.addressTitle,
    //                     style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
    //                   ),
    //                   GestureDetector(
    //                     onTap: () {
    //                       showSearch(
    //                         context: context,
    //                         delegate: SearchLocations(),
    //                       );
    //                     },
    //                     child: Icon(Icons.location_on_outlined),
    //                   ),
    //                 ],
    //               ),
    //               Card(
    //                 child: Container(
    //                   width: MediaQuery.of(context).size.width / 1.1,
    //                   height: 200,
    //                   color: Colors.white,
    //                   child: Column(
    //                     children: [
    //                       Container(
    //                         height: 50,
    //                         width: double.infinity,
    //                         decoration: BoxDecoration(
    //                           border: Border.all(
    //                             color: Colors.grey[200] ?? Colors.black,
    //                           ),
    //                         ),
    //                         child: Center(
    //                           child: Text('Starting soon'),
    //                         ),
    //                       ),
    //                       Row(
    //                         children: [
    //                           Expanded(
    //                             child: Container(
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.grey[200] ?? Colors.black,
    //                                 ),
    //                               ),
    //                               child: Center(
    //                                 child: Text('Today'),
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.grey[200] ?? Colors.black,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Row(
    //                         children: [
    //                           Expanded(
    //                             child: Container(
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.grey[200] ?? Colors.black,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.grey[200] ?? Colors.black,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Row(
    //                         children: [
    //                           Expanded(
    //                             child: Container(
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.grey[200] ?? Colors.black,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Container(
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Colors.grey[200] ?? Colors.black,
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Text(
    //                 "UPCOMING EVENTS NEARBY",
    //                 style: titleStyle,
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               NearbyEventCard(
    //                 onTap: () {
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (_) => EventDetailScreen(),
    //                     ),
    //                   );
    //                 },
    //                 image: image1,
    //                 location: "Kadikoy/Istanbul",
    //                 title: "Dudes Party",
    //               ),
    //               NearbyEventCard(
    //                 onTap: () {},
    //                 image: image2,
    //                 location: "Kadikoy/Istanbul",
    //                 title: "Kadikoy",
    //               ),
    //             ],
    //           ),
    //         ),
    // );
  }
}
