// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      state: json['state'] as int?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isHomeParty: json['isHomeParty'] as bool?,
      maxParticipants: json['maxParticipants'] as int?,
      participiantsLeft: json['participiantsLeft'] as int?,
      eventOwnerId: json['eventOwnerId'] as String?,
      eventPicture: json['eventPicture'] as String?,
      eventOwnerName: json['eventOwnerName'] as String?,
      eventOwnerPicture: json['eventOwnerPicture'] as String?,
      eventId: json['eventId'] as String?,
      participiants: (json['participiants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'title': instance.title,
      'description': instance.description,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'address': instance.address,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isHomeParty': instance.isHomeParty,
      'maxParticipants': instance.maxParticipants,
      'participiantsLeft': instance.participiantsLeft,
      'eventOwnerId': instance.eventOwnerId,
      'eventPicture': instance.eventPicture,
      'eventOwnerName': instance.eventOwnerName,
      'eventOwnerPicture': instance.eventOwnerPicture,
      'participiants': instance.participiants,
    };
