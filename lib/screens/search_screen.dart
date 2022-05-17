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
                await eventProvider.searchEvents();
                // Navigator.pop(context, false);
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
          eventProvider.isWaiting
              ? Center(
                  child: CustomWaitingIndicator(),
                )
              : eventProvider.searchResultList.isEmpty
                  ? Center(
                      child: Text('There is no data'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: eventProvider.searchResultList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EventCard(
                            onTap: () {},
                            title:
                                eventProvider.searchResultList[index].title ??
                                    '',
                            location:
                                eventProvider.searchResultList[index].address ??
                                    '',
                            image: eventProvider
                                    .searchResultList[index].eventPicture ??
                                '');
                      })
        ]),
      ),
    );
  }
}
