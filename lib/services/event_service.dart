import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/models/filter_model.dart';

class EventService {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future<EventModel> createEvent(EventModel event) async {
    try {
      var response = await _firebaseFirestore.collection('events').doc().set(
            event.toJson(),
          );
      return event;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EventModel>> getEventList(FilterModel filters) async {
    final List<EventModel> eventList = [];
    var response = await _firebaseFirestore.collection('events').doc().get();
    var emptyMap = {'aasd': 'sdsd'};
    final eventRef = FirebaseFirestore.instance
        .collection('events')
        .withConverter<EventModel>(
          fromFirestore: (snapshots, _) =>
              EventModel.fromJson(snapshots.data()!),
          toFirestore: (movie, _) => movie.toJson(),
        );
    var events = await eventRef.get();
    events.docs.forEach((element) {
      eventList.add(element.data());
    });
    return eventList;
  }
}
