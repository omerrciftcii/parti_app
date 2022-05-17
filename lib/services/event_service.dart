import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/models/comment_model.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/models/filter_model.dart';
import 'package:parti_app/screens/event_list_screen.dart';

class EventService {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future<EventModel> createEvent(EventModel event) async {
    try {
      var response = await _firebaseFirestore.collection('events').add(
            event.toJson(),
          );
      event.eventId = response.id;
      await _firebaseFirestore.collection('events').doc(event.eventId).update(
            event.toJson(),
          );

      return event;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EventModel>> getEventList(FilterModel filters) async {
    final List<EventModel> eventList = [];
    try {
      var response = await _firebaseFirestore.collection('events').doc().get();
      final eventRef = FirebaseFirestore.instance
          .collection('events')
          .where('isHomeParty', isEqualTo: filters.isHomeParty)
          .where('state', isEqualTo: 1)
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
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<EventModel> getEventDetail(String eventId) async {
    try {
      var eventDetail =
          await _firebaseFirestore.collection('events').doc(eventId).get();

      var convertedResponse = EventModel.fromJson(eventDetail.data() ?? {});

      return convertedResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> joinEvent(eventId, List<String> participants,
      List<String> userAttends, String participiantId) async {
    try {
      await _firebaseFirestore
          .collection('events')
          .doc(eventId)
          .update({'participants': participants});
      await _firebaseFirestore
          .collection('users')
          .doc(participiantId)
          .update({'attents': userAttends});

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<EventModel>> getMyCreatedEvents(
      String currentUserId) async {
    List<EventModel> eventList = [];

    try {
      var events = await _firebaseFirestore
          .collection('events')
          .where('eventOwnerId', isEqualTo: currentUserId)
          .withConverter<EventModel>(
            fromFirestore: (snapshots, _) =>
                EventModel.fromJson(snapshots.data()!),
            toFirestore: (movie, _) => movie.toJson(),
          )
          .get();

      for (var element in events.docs) {
        eventList.add(element.data());
      }
      return eventList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EventModel>> getFutureEvents() async {
    List<EventModel> eventList = [];

    try {
      var events = await _firebaseFirestore
          .collection('events')
          .where('state', isEqualTo: 1)
          // .where(
          //   'startDate',
          //   isLessThanOrEqualTo: DateTime.now().add(
          //     Duration(days: 7),
          //   ),
          // )
          .withConverter<EventModel>(
            fromFirestore: (snapshots, _) =>
                EventModel.fromJson(snapshots.data()!),
            toFirestore: (movie, _) => movie.toJson(),
          )
          .get();

      events.docs.forEach((element) {
        eventList.add(element.data());
      });

      return eventList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EventModel>> myAttendingParties(String userId) async {
    List<EventModel> eventList = [];

    try {
      var events = await _firebaseFirestore
          .collection('events')
          .where(
            'participants',
            arrayContains: userId,
          )
          .where('state', isEqualTo: 1)
          .withConverter<EventModel>(
            fromFirestore: (snapshots, _) =>
                EventModel.fromJson(snapshots.data()!),
            toFirestore: (movie, _) => movie.toJson(),
          )
          .get();

      events.docs.forEach((element) {
        eventList.add(element.data());
      });

      return eventList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> cancelEvent({required String eventId}) async {
    try {
      await _firebaseFirestore
          .collection('events')
          .doc(eventId)
          .update({'state': 0});
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<CommentModel>> getComments({
    required String eventId,
    required bool isReview,
  }) async {
    List<CommentModel> commentList = [];

    try {
      var events = await _firebaseFirestore
          .collection('events')
          .doc(eventId)
          .collection(isReview ? 'questions' : 'reviews')
          .limit(10)
          // .where(
          //   'startDate',
          //   isLessThanOrEqualTo: DateTime.now().add(
          //     Duration(days: 7),
          //   ),
          // )
          .withConverter<CommentModel>(
            fromFirestore: (snapshots, _) =>
                CommentModel.fromJson(snapshots.data()!),
            toFirestore: (movie, _) => movie.toJson(),
          )
          .get();
      if (events.docs.isNotEmpty) {
        for (var element in events.docs) {
          commentList.add(element.data());
        }
      } else {
        print('asdasd');
      }

      return commentList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<CommentModel>? addComment(
      {required CommentModel comment, required bool isReview}) async {
    try {
      await _firebaseFirestore
          .collection('events')
          .doc(comment.eventId)
          .collection(isReview ? 'reviews' : 'questions')
          .doc()
          .set(
            comment.toJson(),
          );

      return comment;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EventModel>> searchEvent(
      {String? query, required String city}) async {
    try {
      List<EventModel> eventList = [];
      var response = await _firebaseFirestore
          .collection('events')
          .where('city', isEqualTo: city)
          .withConverter<EventModel>(
            fromFirestore: (snapshots, _) =>
                EventModel.fromJson(snapshots.data()!),
            toFirestore: (event, _) => event.toJson(),
          )
          .get();
      if (response.docs.isNotEmpty) {
        for (var element in response.docs) {
          eventList.add(element.data());
        }
      } else {}

      return eventList;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<EventModel>> getEvents(
      {required DateTime dateTime}) async {
    try {
      List<EventModel> eventList = [];
      var response = await _firebaseFirestore
          .collection('events')
          .where('city', isEqualTo: city)
          .withConverter<EventModel>(
            fromFirestore: (snapshots, _) =>
                EventModel.fromJson(snapshots.data()!),
            toFirestore: (event, _) => event.toJson(),
          )
          .get();
      if (response.docs.isNotEmpty) {
        for (var element in response.docs) {
          eventList.add(element.data());
        }
      } else {}

      return eventList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
