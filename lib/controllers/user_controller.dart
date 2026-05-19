import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  String firstName = "";
  String lastName = "";
  String email = "";

  String gender = "";
  String phone = "";
  String address = "";
  String countryCode = "+91";

  String dob = "";

  bool isSubmitted = false;
  String? countryError;

  File? userImage;

  String? imageError;

  bool get isProfileComplete {
    return gender.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        dob.isNotEmpty &&
        userImage != null;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    firstName = prefs.getString("userFirstname") ?? "";

    lastName = prefs.getString("userSecondname") ?? "";

    email = prefs.getString("email") ?? "";

    gender = prefs.getString("gender") ?? "";

    phone = prefs.getString("phone") ?? "";

    address = prefs.getString("address") ?? "";

    countryCode = prefs.getString("countryCode") ?? "+91";

    dob = prefs.getString("dob") ?? "";

    final imagePath = prefs.getString("imagePath_${email}");

    if (imagePath != null && File(imagePath).existsSync()) {
      userImage = File(imagePath);
    }
    update();
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("gender", gender);

    await prefs.setString("phone", phone);

    await prefs.setString("address", address);

    await prefs.setString("countryCode", countryCode);

    await prefs.setString("dob", dob);

    if (userImage != null) {
      await prefs.setString("imagePath_${email}", userImage!.path);
    }
    update();
  }

  Future<void> pickDOB(DateTime pickedDate) async {
    dob = pickedDate.toIso8601String();
    update();
  }

  void setUserImage(File imageFile) {
    userImage = imageFile;
    update();
  }
}
