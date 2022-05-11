import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parti_app/models/city_search_model.dart';
import 'package:parti_app/providers/event_provider.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:parti_app/widgets/waiting_indicator.dart';
import 'package:provider/provider.dart';

import '../services/google_services.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
// TODO: implement query
  String get query => super.query;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    return FutureBuilder<List<CitySearchModel>>(
      future: GoogleServices.fetchSuggestions(query, 'tr'),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CustomWaitingIndicator();
          default:
            if (snapshot.hasError) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name ?? ''),
                      onTap: () {
                        eventProvider.searchCitySelection =
                            snapshot.data![index].name;
                        Navigator.pop(context, snapshot.data![index].name);
                      },
                    );
                  });
            }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: FutureBuilder<List<CitySearchModel>>(
          future: eventProvider.searchCitiesFuture,
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CustomWaitingIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final suggestion = snapshot.data![index];
                  final queryText = suggestion.name!.substring(0, query.length);
                  final remainingText =
                      suggestion.name!.substring(query.length);

                  return ListTile(
                    onTap: () {
                      query = suggestion.name ?? '';

                      // 1. Show Results
                      showResults(context);

                      // 2. Close Search & Return Result
                      // close(context, suggestion);

                      // 3. Navigate to Result Page
                      //  Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => ResultPage(suggestion),
                      //   ),
                      // );
                    },

                    leading: Icon(Icons.location_city),
                    // title: Text(suggestion),
                    title: RichText(
                      text: TextSpan(
                        text: queryText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: remainingText,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'An error has occured',
                  style: GoogleFonts.jost(color: Colors.white),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'An error has occured2',
                  style: GoogleFonts.jost(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildNoSuggestions() => Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'No suggestions!',
            style: TextStyle(fontSize: 28, color: Colors.black),
          ),
        ),
      );
}
