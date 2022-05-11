import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/screens/event_detail_screen.dart';
import 'package:parti_app/screens/search_screen.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:parti_app/widgets/new_event_card_widget.dart';
import 'package:parti_app/widgets/waiting_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventProvider.futureEventsFuture = EventService.getFutureEvents();
      eventProvider.myAttendingParties =
          EventService.myAttendingParties(authProvider.currentUser!.userId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                pushNewScreen(context, screen: SearchPage(), withNavBar: false);
              },
              icon: Icon(
                Icons.search,
                color: Colors.orange,
              ),
            )
          ],
          title: Text(
            'PartyUp',
            style: GoogleFonts.jost(color: Colors.black),
          ),
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/arabica-148 1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 10, left: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: 200,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[200] ?? Colors.black,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Starting soon',
                                    style: GoogleFonts.jost(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey[200] ?? Colors.black,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Today',
                                          style: GoogleFonts.jost(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey[200] ?? Colors.black,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Tomorrow',
                                          style: GoogleFonts.jost(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey[200] ?? Colors.black,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'This Week',
                                          style: GoogleFonts.jost(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey[200] ?? Colors.black,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Next Week',
                                          style: GoogleFonts.jost(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey[200] ?? Colors.black,
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        'All Upcoming',
                                        style: GoogleFonts.jost(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Future Events!',
                        style: GoogleFonts.jost(
                            color: Color(0xff7C7C7C), fontSize: 20),
                      ),
                      FutureBuilder<List<EventModel>>(
                        future: eventProvider.futureEventsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CustomWaitingIndicator();
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData == true &&
                              snapshot.data!.isNotEmpty &&
                              snapshot.hasError == false) {
                            return Container(
                              height: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 14.0),
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            pushNewScreen(context,
                                                screen: EventDetailScreen(
                                                    eventID: snapshot
                                                            .data![index]
                                                            .eventId ??
                                                        ''),
                                                withNavBar: false);
                                          },
                                          child: NewEventCardWidget(
                                            event: snapshot.data![index],
                                            width: 130,
                                            height: 160,
                                          ),
                                        ),
                                        Positioned(
                                            width: 130,
                                            bottom: 10,
                                            child: Text(
                                              snapshot.data![index].title ?? '',
                                              maxLines: 2,
                                              style: GoogleFonts.jost(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData == true &&
                              snapshot.data!.isEmpty &&
                              snapshot.hasError == false) {
                            return Center(
                              child: Text('There is no event in the futere'),
                            );
                          } else {
                            return Center(
                              child: Text('An error has occured'),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Visibility(
                        visible: true,
                        child: Text(
                          'PARTIES I WILL ATTEND',
                          style: GoogleFonts.jost(
                              color: Color(0xff7C7C7C), fontSize: 20),
                        ),
                      ),
                      FutureBuilder<List<EventModel>>(
                        future: eventProvider.myAttendingParties,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CustomWaitingIndicator();
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData == true &&
                              snapshot.data!.isNotEmpty &&
                              snapshot.hasError == false) {
                            return Column(
                              children: [
                                Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            pushNewScreen(context,
                                                screen: EventDetailScreen(
                                                    eventID: snapshot
                                                            .data![index]
                                                            .eventId ??
                                                        ''),
                                                withNavBar: false);
                                          },
                                          child: NewEventCardWidget(
                                            event: snapshot.data![index],
                                            width: double.infinity,
                                            height: 120,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData == true &&
                              snapshot.data!.isEmpty &&
                              snapshot.hasError == false) {
                            return Center(
                              child: Text('There is no event in the futere'),
                            );
                          } else {
                            return Center(
                              child: Text(
                                snapshot.error.toString(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
