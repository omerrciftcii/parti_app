// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      name: json['name'] as String,
      userId: json['userId'] as String,
      age: json['age'] as int?,
      isPremium: json['isPremium'] as bool?,
      profilePicture: json['profilePicture'] as String?,
      email: json['email'] as String,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'name': instance.name,
      'userId': instance.userId,
      'age': instance.age,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'isPremium': instance.isPremium,
      'provider': instance.provider,
    };
