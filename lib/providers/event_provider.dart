import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/constants/constants.dart';
import 'package:parti_app/helpers/email_helper.dart';
import 'package:parti_app/models/comment_model.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/models/failure.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:http/http.dart' as http;
import '../models/place_search.dart';

class EventProvider extends ChangeNotifier {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isHomeParty = true;
  bool _isWaiting = false;
  bool get isWaiting => _isWaiting;
  Future<List<EventModel>>? _eventListFuture;
  Future<List<EventModel>>? get eventListFuture => _eventListFuture;
  Future<EventModel>? _eventDetailFuture;
  Future<List<EventModel>>? _myCreatedEventsFuture;
  Future<List<EventModel>>? _futureEventsFuture;
  Future<List<EventModel>>? get futureEventsFuture => _futureEventsFuture;
  Future<List<EventModel>>? _myAttendingParties;
  Future<List<EventModel>>? get myAttendingParties => _myAttendingParties;

  Future<List<CommentModel>>? _getCommentsFuture;
  Future<List<CommentModel>>? get getCommentsFuture => _getCommentsFuture;
  set getCommentsFuture(value) {
    _getCommentsFuture = value;
    notifyListeners();
  }

  late TabController _commentsTabController;
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(value) {
    _selectedTabIndex = value;
    notifyListeners();
  }

  TabController get commnetsTabController => _commentsTabController;
  set commnetsTabController(value) {
    _commentsTabController = value;
    notifyListeners();
  }

  set myAttendingParties(value) {
    _myAttendingParties = value;
    notifyListeners();
  }

  set futureEventsFuture(value) {
    _futureEventsFuture = value;
    notifyListeners();
  }

  Future<List<EventModel>>? get myCreatedEventsFuture => _myCreatedEventsFuture;
  set myCreatedEventsFuture(value) {
    _myCreatedEventsFuture = value;
    notifyListeners();
  }

  Future<EventModel>? get eventDetailFuture => _eventDetailFuture;
  set eventDetailFuture(value) {
    _eventDetailFuture = value;
    notifyListeners();
  }

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  set eventListFuture(value) {
    _eventListFuture = value;
    notifyListeners();
  }

  set isWaiting(value) {
    _isWaiting = value;
    notifyListeners();
  }

  String? _currentCountry;
  String? _currentState;
  String? _currentCity;
  LatLng? _selectedLocation;
  LatLng? get selectedLocation => _selectedLocation;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController get startDateController => _startDateController;
  TextEditingController _endDateController = TextEditingController();
  TextEditingController get endDateController => _endDateController;
  TextEditingController _maxParticipiantController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController get imageController => _imageController;

  TextEditingController get maxParticipiantController =>
      _maxParticipiantController;
  XFile? _selectedEventImages;
  final ImagePicker _picker = ImagePicker();

  XFile? get selectedEventImages => _selectedEventImages;
  set selectedEventImages(value) {
    _selectedEventImages = value;
    notifyListeners();
  }

  set selectedLocation(value) {
    _selectedLocation = value;
    notifyListeners();
  }

  final TextEditingController _addressTitleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  //Getters-Setters
  String? get currentCity => _currentCity;
  set currentCity(value) {
    _currentCity = value;
    notifyListeners();
  }

  String? get currentState => _currentState;
  set currentState(value) {
    _currentState = value;
    notifyListeners();
  }

  String? get currentCountry => _currentCountry;
  set currentCountry(value) {
    _currentCountry = value;
    notifyListeners();
  }

  List<PlaceSearch>? _searchResults = [];
  List<PlaceSearch>? get searchResults => _searchResults;
  TextEditingController get addressController => _addressController;
  TextEditingController get addressTitleController => _addressTitleController;
  DateTime _selectedStartDate = DateTime.now();
  String? _selectedEventPicture;
  String? get selectedEventPicture => _selectedEventPicture;
  set selectedEventPicture(value) {
    _selectedEventPicture = value;
    notifyListeners();
  }

  DateTime get selectedStartDate => _selectedStartDate;
  set selectedStartDate(value) {
    _selectedStartDate = value;
    notifyListeners();
  }

  DateTime _selectedEndDate = DateTime.now();
  DateTime get selectedEndDate => _selectedStartDate;
  set selectedEndDate(value) {
    _selectedEndDate = value;
    notifyListeners();
  }

  TextEditingController get titleController => _titleController;
  TextEditingController get descriptionController => _descriptionController;
  bool get isHomeParty => _isHomeParty;
  set isHomeParty(value) {
    _isHomeParty = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    if (isStartDate) {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedStartDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101));
      var selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != selectedStartDate) {
        selectedStartDate = picked;
        selectedStartDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime!.hour,
          selectedTime.minute,
        );
        startDateController.text = selectedStartDate.toString();
      }
    } else {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedEndDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101));
      var selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != selectedEndDate) {
        selectedEndDate = picked;
        selectedEndDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime!.hour,
          selectedTime.minute,
        );
        endDateController.text = selectedStartDate.toString();
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? image;

    image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    if (image != null) {
      var convertedImage = File(image.path);
      List<int> imageBytes = convertedImage.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      selectedEventPicture = base64Image;
      imageController.text = image.name;
    }
  }

  Future<EventModel> createEvent(
      String userId, String eventOwnerName, String eventOwnerPicture) async {
    isWaiting = true;
    try {
      var event = EventModel(
        title: titleController.text,
        description: descriptionController.text,
        city: currentCity,
        country: currentCountry,
        address: addressController.text,
        isHomeParty: isHomeParty,
        maxParticipants: int.parse(maxParticipiantController.text),
        endDate: selectedEndDate,
        startDate: selectedStartDate,
        latitude: selectedLocation!.latitude,
        longitude: selectedLocation!.longitude,
        eventOwnerId: userId,
        participiantsLeft: int.parse(maxParticipiantController.text) - 1,
        eventPicture: selectedEventPicture,
        eventOwnerName: eventOwnerName,
        eventOwnerPicture: eventOwnerPicture,
        participiants: [],
      );
      var response = await EventService.createEvent(event);
      isWaiting = false;

      return response;
    } catch (e) {
      isWaiting = false;
      throw Failure(
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> joinParty({
    required String eventId,
    required String eventTitle,
    required String eventDescription,
    required String partyOwnerName,
    required String dateTime,
    required String place,
    required String address,
    required String participiantId,
    required List<String> participiants,
    required List<String> attents,
    required String participantName,
  }) async {
    isWaiting = true;
    var headers = {
      'Authorization':
          'Bearer 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',
      'Content-Type': 'application/json',
    };

    var data = {
      "from": {"email": "omerrcftcc@gmail.com"},
      "personalizations": [
        {
          "to": [
            {"email": "shamkhalbaghishov@gmail.com"}
          ],
          "subject": "Party Invitation",
        }
      ],
      "content": [
        {
          "type": "text/html",
          "value": EmailHelper.htmlHelper(
            partyName: eventTitle,
            partyOwnerName: partyOwnerName,
            dateTime: dateTime,
            place: place,
            address: address,
            participant: participantName,
          ),
        }
      ],
    };
    try {
      var url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
      var res = await http.post(url, headers: headers, body: jsonEncode(data));
      attents.add(eventId);
      if (res.statusCode != 202) {
        isWaiting = false;
        return false;
      }
      participiants.add(participiantId);
      await EventService.joinEvent(
        eventId,
        participiants,
        attents,
        participiantId,
      );
      isWaiting = false;
      return true;
    } catch (e) {
      isWaiting = false;
      return false;
    }
  }

  Future<bool> cancelEvent({required EventModel event}) async {
    try {
      isWaiting = true;
      var response =
          await EventService.cancelEvent(eventId: event.eventId ?? '');

      if (response == true) {
        isWaiting = false;
        return true;
      } else {
        isWaiting = false;
        return false;
      }
    } catch (e) {
      isWaiting = false;
      return false;
    }
  }
  //Email sender

}
