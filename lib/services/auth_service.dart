import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parti_app/models/app_user.dart';

class AuthService {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static Future<AppUser> addUserToDb(AppUser userData) async {
    var response =
        await _firebaseFirestore.collection('users').doc(userData.userId).set(
              userData.toJson(),
            );
    return userData;
  }

  static Future<AppUser> getCurrentUser(String userId) async {
    var response =
        await _firebaseFirestore.collection('users').doc(userId).get();
    return AppUser.fromJson(response.data() ?? {});
  }

  static Future<bool> isUserExist(String userId) async {
    var result = await _firebaseFirestore.collection('users').doc(userId).get();
    return result.exists;
  }
}
