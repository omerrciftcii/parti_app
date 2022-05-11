// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      comment: json['comment'] as String,
      createdById: json['createdById'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      reviewerName: json['reviewerName'] as String,
      reviewerProfilePicture: json['reviewerProfilePicture'] as String,
      eventId: json['eventId'] as String,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'createdById': instance.createdById,
      'reviewerName': instance.reviewerName,
      'createdDate': instance.createdDate.toIso8601String(),
      'reviewerProfilePicture': instance.reviewerProfilePicture,
      'eventId': instance.eventId,
    };
