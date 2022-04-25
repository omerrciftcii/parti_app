// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterModel _$FilterModelFromJson(Map<String, dynamic> json) => FilterModel(
      city: json['city'] as String?,
      eventPerPage: json['eventPerPage'] as String?,
      query: json['query'] as String?,
      isHomeParty: json['isHomeParty'] as bool,
    );

Map<String, dynamic> _$FilterModelToJson(FilterModel instance) =>
    <String, dynamic>{
      'eventPerPage': instance.eventPerPage,
      'city': instance.city,
      'query': instance.query,
      'isHomeParty': instance.isHomeParty,
    };
