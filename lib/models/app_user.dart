import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  final String name;
  final String userId;
  int? age;
  final String email;
  String? profilePicture;
  bool? isPremium;
  String? provider;
  List<String>? attents = [];
  String? deviceToken;

  AppUser(
      {required this.name,
      required this.userId,
      this.age,
      this.isPremium,
      this.profilePicture,
      required this.email,
      this.provider,
      this.attents,
      required this.deviceToken});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
