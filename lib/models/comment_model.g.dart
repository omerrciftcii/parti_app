// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      comment: json['comment'] as String,
      createdBy: json['createdBy'] as String,
      createdDate: json['createdDate'] as String,
      reviewerName: json['reviewerName'] as String,
      reviewerProfilePicture: json['reviewerProfilePicture'] as String,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'createdBy': instance.createdBy,
      'reviewerName': instance.reviewerName,
      'createdDate': instance.createdDate,
      'reviewerProfilePicture': instance.reviewerProfilePicture,
    };
