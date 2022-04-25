import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:parti_app/providers/auth_provider.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:parti_app/widgets/waiting_indicator.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card_widget.dart';
import 'event_detail_screen.dart';

class MyCreatedEvents extends StatefulWidget {
  MyCreatedEvents({Key? key}) : super(key: key);

  @override
  State<MyCreatedEvents> createState() => _MyCreatedEventsState();
}

class _MyCreatedEventsState extends State<MyCreatedEvents> {
  TextAlign? textAlign = TextAlign.end;
  bool isConfirmed = false;
  @override
  void initState() {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventProvider.myCreatedEventsFuture =
          EventService.getMyCreatedEvents(authProvider.currentUser!.userId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      body: FutureBuilder<List<EventModel>>(
        future: eventProvider.myCreatedEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomWaitingIndicator();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError == false &&
              snapshot.hasData &&
              snapshot.data!.length != 0) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Dismissible(
                              child: EventCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EventDetailScreen(
                                            eventID:
                                                snapshot.data![index].eventId ??
                                                    ''),
                                      ),
                                    );
                                  },
                                  title: snapshot.data![index].title ?? '',
                                  location: snapshot.data![index].city ?? '',
                                  image:
                                      snapshot.data![index].eventPicture ?? ''),
                              key: Key(snapshot.data![index].eventId ?? ''),
                              background: Container(
                                color: Colors.red,
                                child: Center(
                                  child: Text(
                                    'Cancel Event',
                                    textAlign: textAlign,
                                    style: GoogleFonts.jost(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (isConfirmed) async {
                                var result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: eventProvider.isWaiting
                                            ? Center(
                                                child: CustomWaitingIndicator(),
                                              )
                                            : Text(
                                                'You are deleting this event, participants will be notified. Are You sure?',
                                                style: GoogleFonts.jost(
                                                    color: Colors.black),
                                              ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await eventProvider.cancelEvent(
                                                  event: snapshot.data![index]);
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text(
                                              'Yes',
                                              style: GoogleFonts.jost(
                                                  color: Colors.red[900],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'No',
                                              style: GoogleFonts.jost(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    });

                                if (result == true) {
                                  setState(() {
                                    snapshot.data!
                                        .remove(snapshot.data![index]);
                                  });
                                }
                              },
                              onDismissed: (direction) async {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError == false &&
              snapshot.data!.length == 0) {
            return Center(
              child: Text('There is no events nearby'),
            );
          } else {
            throw Exception(snapshot.error);
          }
        },
      ),
    );
  }
}
