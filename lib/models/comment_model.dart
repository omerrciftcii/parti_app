import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String comment;
  final String createdBy;
  final String reviewerName;
  final String createdDate;
  final String reviewerProfilePicture;

  CommentModel(
      {required this.comment,
      required this.createdBy,
      required this.createdDate,
      required this.reviewerName,
      required this.reviewerProfilePicture});

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
