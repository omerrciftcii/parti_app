import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/utils/search_delegate.dart';
import 'package:parti_app/widgets/custom_textfield.dart';
import 'package:parti_app/widgets/event_card_widget.dart';
import 'package:parti_app/widgets/waiting_indicator.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(
      context,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24),
        child: Column(children: [
          SizedBox(
            height: 48,
          ),
          CustomTextField(
              controller: eventProvider.searchEventController,
              prefixIcon: FaIcon(Icons.chevron_left),
              hintText: 'Upcoming Events',
              validator: (query) {
                if (query!.isEmpty) {
                  return 'You should enter some text';
                }
              }),
          CustomTextField(
            controller: eventProvider.searchCityController,
            hintText: 'Search Cities',
            onTap: () async {
              await showSearch(
                context: context,
                delegate: CitySearchDelegate(),
              );
              print(eventProvider.searchCitySelection);
              if (eventProvider.searchCitySelection != null &&
                  eventProvider.searchCitySelection!.isNotEmpty) {

                eventProvider.searchEventFuture = 
                eventProvider.showSearchResult = true;
              } else {
                Navigator.pop(context, false);
              }
              print('sdd');
            },
            validator: (query) {
              if (query!.isEmpty) {
                return 'You should enter some text';
              }
            },
            prefixIcon: FaIcon(Icons.location_city),
          ),
          Visibility(
            visible: eventProvider.showSearchResult,
            child: FutureBuilder<List<EventModel>>(
              future: eventProvider.searchEventFuture,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CustomWaitingIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                    return EventCard(
                        onTap: () {},
                        title: snapshot.data![index].title ?? '',
                        location: snapshot.data![index].address ?? '',
                        image: snapshot.data![index].eventPicture ?? '');
                  });
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('There is no data'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'An error has occured',
                      style: GoogleFonts.jost(),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('Unknown'),
                  );
                }
              }),
            ),
          ),
        ]),
      ),
    );
  }
}
