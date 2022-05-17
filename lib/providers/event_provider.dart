import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/helpers/email_helper.dart';
import 'package:parti_app/models/city_search_model.dart';
import 'package:parti_app/models/comment_model.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/models/failure.dart';
import 'package:parti_app/services/event_service.dart';
import 'package:http/http.dart' as http;
import 'package:parti_app/utils/datetime_helper.dart';
import '../models/place_search.dart';

class EventProvider extends ChangeNotifier {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchCityController = TextEditingController();

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
  List<EventModel> _searchResultList = [];
  List<EventModel> get searchResultList => _searchResultList;
  String? _searchCitySelection;
  String? get searchCitySelection => _searchCitySelection;
  Future<List<EventModel>>? _searchEventFuture;
  Future<List<EventModel>>? get searchEventFuture => _searchEventFuture;
  bool _showSearchResult = false;
  bool _reviewSelected = false;
  bool get reviewSelected => _reviewSelected;
  set reviewSelected(value) {
    _reviewSelected = value;
    notifyListeners();
  }

  List<EventModel> _searchEventResult = [];
  List<EventModel> get searchEventResult => _searchEventResult;
  set searchEventResult(value) {
    _searchEventResult = value;
    notifyListeners();
  }

  bool get showSearchResult => _showSearchResult;
  set showSearchResult(value) {
    _showSearchResult = value;
    notifyListeners();
  }

  set searchEventFuture(value) {
    _searchEventFuture = value;
    notifyListeners();
  }

  set searchCitySelection(value) {
    _searchCitySelection = value;
    notifyListeners();
  }

  set searchResultList(value) {
    _searchResultList = value;
    notifyListeners();
  }

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
  final TextEditingController _startDateController = TextEditingController();
  TextEditingController get startDateController => _startDateController;
  TextEditingController get searchCityController => _searchCityController;

  final TextEditingController _endDateController = TextEditingController();
  TextEditingController get endDateController => _endDateController;
  final TextEditingController _maxParticipiantController =
      TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  TextEditingController get imageController => _imageController;
  final TextEditingController _commentController = TextEditingController();
  TextEditingController get commentController => _commentController;
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
  TextEditingController _searchEventController = TextEditingController();
  TextEditingController get searchEventController => _searchEventController;
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
          initialEntryMode: TimePickerEntryMode.input);
      if (picked != null && picked != selectedStartDate) {
        selectedStartDate = picked;
        selectedStartDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime!.hour,
          selectedTime.minute,
        );
        startDateController.text =
            DateTimeHelper.getDateTime(selectedStartDate);
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
          initialEntryMode: TimePickerEntryMode.input);
      if (picked != null && picked != selectedEndDate) {
        selectedEndDate = picked;
        selectedEndDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime!.hour,
          selectedTime.minute,
        );
        endDateController.text = DateTimeHelper.getDateTime(selectedEndDate);
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? image;

    image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
    if (image != null) {
      var convertedImage = await testCompressAndGetFile(File(image.path), './');

      List<int> imageBytes = convertedImage.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      selectedEventPicture = base64Image;
      imageController.text = image.name;
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
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

  Future<void> searchEvents() async {
    try {
      isWaiting = true;
      var result =
          await EventService.searchEvent(city: searchCitySelection ?? '');
      searchResultList = result;
      isWaiting = false;
    } catch (e) {
      isWaiting = false;
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
  Future<CommentModel> addComment(
      {required String eventId,
      required String reviewerName,
      required String createdById,
      required String comment,
      required bool isReview,
      required String reviewerProfilePicture}) async {
    CommentModel commentModel = CommentModel(
      comment: comment,
      createdById: createdById,
      createdDate: DateTime.now(),
      reviewerName: reviewerName,
      reviewerProfilePicture: reviewerProfilePicture,
      eventId: eventId,
    );

    try {
      isWaiting = true;
      var response = await EventService.addComment(
          comment: commentModel, isReview: isReview);
      isWaiting = false;
      return commentModel;
    } catch (e) {
      isWaiting = false;
      throw Exception(e);
    }
  }

  Future<List<CitySearchModel>>? _searchCitiesFuture;
  Future<List<CitySearchModel>>? get searchCitiesFuture => _searchCitiesFuture;
  set searchCitiesFuture(value) {
    _searchCitiesFuture = value;
    notifyListeners();
  }
}
