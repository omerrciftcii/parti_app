import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String comment;
  final String createdById;
  final String reviewerName;
  final DateTime createdDate;
  final String reviewerProfilePicture;
  final String eventId;

  CommentModel({
    required this.comment,
    required this.createdById,
    required this.createdDate,
    required this.reviewerName,
    required this.reviewerProfilePicture,
    required this.eventId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
