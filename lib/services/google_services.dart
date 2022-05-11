import 'dart:convert';

import 'package:http/http.dart';
import 'package:parti_app/constants/constants.dart';
import 'package:parti_app/models/city_search_model.dart';

import '../models/suggestion_model.dart';

class GoogleServices {
  static final client = Client();

  static Future<List<CitySearchModel>> fetchSuggestions(
      String input, String lang) async {
    final request =
        'https://spott.p.rapidapi.com/places/autocomplete?limit=10&skip=0&q=$input&type=CITY';
    final response = await client.get(Uri.parse(request), headers: {
      'X-RapidAPI-Key': '9a8bc81ea3msheebc51b0e9fe75fp13815djsn82b774a030f1'
    });
    try {
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // compose suggestions in a list
        var cityList = (json.decode(response.body) as List)
            .map((i) => CitySearchModel.fromJson(i))
            .toList();
        print('asd');
        return cityList;
      } else {
        throw Exception('Failed to fetch suggestion');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
