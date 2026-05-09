import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;

  RxString gender = "".obs;
  RxString phone = "".obs;
  RxString address = "".obs;
  RxString countryCode = "+91".obs;

  RxString dob = "".obs;

  Rx<File?> userImage = Rx<File?>(null);

  bool get isProfileComplete {
    return gender.value.isNotEmpty &&
        phone.value.isNotEmpty &&
        address.value.isNotEmpty &&
        dob.value.isNotEmpty &&
        userImage.value != null;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    firstName.value = prefs.getString("userFirstname") ?? "";

    lastName.value = prefs.getString("userSecondname") ?? "";

    email.value = prefs.getString("email") ?? "";

    gender.value = prefs.getString("gender") ?? "";

    phone.value = prefs.getString("phone") ?? "";

    address.value = prefs.getString("address") ?? "";

    countryCode.value = prefs.getString("countryCode") ?? "+91";

    dob.value = prefs.getString("dob") ?? "";

    final imagePath = prefs.getString("imagePath_${email.value}");

    if (imagePath != null && File(imagePath).existsSync()) {
      userImage.value = File(imagePath);
    }
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("gender", gender.value);

    await prefs.setString("phone", phone.value);

    await prefs.setString("address", address.value);

    await prefs.setString("countryCode", countryCode.value);

    await prefs.setString("dob", dob.value);

    if (userImage.value != null) {
      await prefs.setString("imagePath_${email.value}", userImage.value!.path);
    }
  }

  Future<void> pickDOB(DateTime pickedDate) async {
    dob.value = pickedDate.toIso8601String();
  }

  void setUserImage(File imageFile) {
    userImage.value = imageFile;
  }
}
