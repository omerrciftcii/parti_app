import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parti_app/models/app_user.dart';
import 'package:parti_app/services/profile_service.dart';

class UserProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  Future<AppUser?> changeProfilePicture(
      String userId, AppUser? user, bool isCamera) async {
    final XFile? image;
    if (isCamera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (image != null) {
      var profilePictureUrl =
          await ProfileService.uploadProfilePicture(image, userId);
      user!.profilePicture = profilePictureUrl;
      return await ProfileService.updateUser(user);
    }
    return user;
  }
}
