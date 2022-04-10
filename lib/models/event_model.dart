import 'package:json_annotation/json_annotation.dart';
part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  String? title;
  String? description;
  String? country;
  String? state;
  String? city;
  String? address;
  DateTime? startDate;
  DateTime? endDate;
  double? latitude;
  double? longitude;
  bool? isHomeParty;
  int? maxParticipants;
  int? participiantsLeft;
  String? eventOwnerId;
  String? eventPicture;

  EventModel({
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.country,
    this.state,
    required this.startDate,
    required this.endDate,
    required this.latitude,
    required this.longitude,
    required this.isHomeParty,
    required this.maxParticipants,
    required this.participiantsLeft,
    required this.eventOwnerId,
    this.eventPicture,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
