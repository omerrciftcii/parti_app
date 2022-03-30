import 'dart:convert';

import 'package:http/http.dart';
import 'package:parti_app/constants/constants.dart';

import '../models/suggestion_model.dart';

class GoogleServices {
  static final client = Client();

  static Future<List<SuggestionModel>> fetchSuggestions(
      String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ch&key=${Constants.googleApiKey}';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<SuggestionModel>((p) => SuggestionModel(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
