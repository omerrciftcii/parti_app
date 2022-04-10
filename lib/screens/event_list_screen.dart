import 'package:flutter/material.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/models/filter_model.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:parti_app/widgets/event_card_widget.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatefulWidget {
  EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      eventProvider.eventListFuture = EventService.getEventList(FilterModel());
    }); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      body: FutureBuilder<List<EventModel>>(
        future: eventProvider.eventListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError == false &&
              snapshot.hasData &&
              snapshot.data!.length != 0) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return EventCard(
                      onTap: () {},
                      title: snapshot.data![index].title ?? '',
                      location: snapshot.data![index].city ?? '',
                      image: snapshot.data![index].eventPicture ?? '');
                });
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError != false &&
              snapshot.hasData &&
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
