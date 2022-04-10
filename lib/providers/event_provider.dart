import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/models/event_model.dart';
import 'package:parti_app/models/failure.dart';
import 'package:parti_app/services/event_service.dart';

import '../models/place_search.dart';

class EventProvider extends ChangeNotifier {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isHomeParty = true;
  bool _isWaiting = false;
  bool get isWaiting => _isWaiting;
  Future<List<EventModel>>? _eventListFuture;
  Future<List<EventModel>>? get eventListFuture => _eventListFuture;
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

    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var convertedImage = File(image.path);
      List<int> imageBytes = convertedImage.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      selectedEventPicture = base64Image;
      imageController.text = image.name;
    }
  }

  Future<EventModel> createEvent(String userId) async {
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
}
