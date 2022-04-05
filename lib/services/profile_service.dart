import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/models/app_user.dart';

class ProfileService {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future<AppUser> updateUser(AppUser user) async {
    try {
      await _firebaseFirestore.collection('users').doc(user.userId).update(
            user.toJson(),
          );
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String?> uploadProfilePicture(XFile file, String userId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      File convertedFile = File(file.path);
      UploadTask uploadTask;

      // Create a Reference to the file
      Reference ref =
          FirebaseStorage.instance.ref().child('profiles').child(userId);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );
      uploadTask = ref.putFile(File(file.path), metadata);
      return await (await uploadTask).ref.getDownloadURL();
      // var response = await Future.value(uploadTask);
      // return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(e);
    }
  }
}
