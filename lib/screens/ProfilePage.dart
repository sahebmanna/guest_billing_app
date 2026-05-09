import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  String? countryError;

  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final userController = Get.find<UserController>();

  //Bottom sheet of upload image options

  void showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            //  IMPORTANT FIX
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Use Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {
    await userController.loadUserData();

    phoneController.text = userController.phone.value;

    addressController.text = userController.address.value;
  }

  Future<void> pickImage(ImageSource source) async {
    final img = await _picker.pickImage(source: source);

    if (img != null) {
      userController.setUserImage(File(img.path));
    }
  }

  Future<void> pickDOB() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: DateTime(2000),

      firstDate: DateTime(1900),

      lastDate: DateTime.now(),
    );

    if (picked != null) {
      await userController.pickDOB(picked);
    }
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  InputDecoration style(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
      ),

      // =========================
      // RIGHT DRAWER
      // =========================
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            UserAccountsDrawerHeader(
              accountName: Obx(
                () => Text(
                  "${userController.firstName.value} "
                  "${userController.lastName.value}",
                ),
              ),

              accountEmail: Obx(() => Text(userController.email.value)),

              currentAccountPicture: Obx(
                () => CircleAvatar(
                  backgroundImage: userController.userImage.value != null
                      ? FileImage(userController.userImage.value!)
                      : null,

                  child: userController.userImage.value == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
            ),
            // Profile
            ListTile(
              leading: const Icon(Icons.account_circle),

              title: const Text("Profile"),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            // DASHBOARD
            Obx(
              () => ListTile(
                leading: Icon(
                  Icons.dashboard,

                  color: userController.isProfileComplete
                      ? Colors.black
                      : Colors.grey,
                ),

                title: Text(
                  "Dashboard",

                  style: TextStyle(
                    color: userController.isProfileComplete
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),

                onTap: () {
                  if (!userController.isProfileComplete) {
                    Get.snackbar("Incomplete", "Complete profile first");

                    return;
                  }

                  Get.toNamed('/Dashboard');
                },
              ),
            ),
            // GUEST DETAILS
            Obx(
              () => ListTile(
                leading: Icon(
                  Icons.people,

                  color: userController.isProfileComplete
                      ? Colors.black
                      : Colors.grey,
                ),

                title: Text(
                  "Guest Details",

                  style: TextStyle(
                    color: userController.isProfileComplete
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),

                onTap: () {
                  if (!userController.isProfileComplete) {
                    Get.snackbar("Incomplete", "Complete profile first");

                    return;
                  }

                  Navigator.pushNamed(context, '/guestDetails');
                },
              ),
            ),
          ],
        ),
      ),

      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: _isSubmitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                Text('Complete Your Profile', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),

                // Profile Image + Edit
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: userController.userImage.value != null
                          ? FileImage(userController.userImage.value!)
                          : null,
                      child: userController.userImage.value == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: showImageSourceSheet,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Name (read only)
                buildLabel("First Name"),

                TextField(
                  readOnly: true,
                  decoration: style(userController.firstName.value),
                ),
                const SizedBox(height: 4),
                buildLabel("Last Name"),
                TextField(
                  readOnly: true,
                  decoration: style(userController.lastName.value),
                ),

                const SizedBox(height: 4),
                //Gender dropdown
                buildLabel("Gender"),

                DropdownButtonFormField<String>(
                  initialValue: userController.gender.value == ""
                      ? null
                      : userController.gender.value,
                  hint: const Text("Select Gender"),
                  items: ["Male", "Female", "Other"]
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) {
                    userController.gender.value = val!;
                  },
                  decoration: style(""),
                  validator: (value) {
                    if (value == null) {
                      return "Please select gender";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 4),

                //Email (read only)
                buildLabel("Email ID"),
                //SizedBox(height: 5),
                TextField(
                  readOnly: true,
                  decoration: style(userController.email.value),
                ),

                const SizedBox(height: 4),

                // Phone with country code
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLabel("Phone Number"),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            value: userController.countryCode.value,
                            underline: const SizedBox(),
                            items: ["+91", "+1", "+44"]
                                .map(
                                  (code) => DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              userController.countryCode.value = val!;
                              setState(() {
                                countryError = null;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: style("Phone number"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone number is required";
                              }
                              if (value.length != 10) {
                                return "Must be 10 digits";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    if (countryError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          countryError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                buildLabel("Date Of Birth"),
                Obx(
                  () => TextField(
                    readOnly: true,
                    onTap: pickDOB,
                    decoration: style("Date of Birth").copyWith(
                      hintText: userController.dob.value.isEmpty
                          ? "Select Date"
                          : "${DateTime.parse(userController.dob.value).day}/${DateTime.parse(userController.dob.value).month}/${DateTime.parse(userController.dob.value).year}",
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                //  Address (3–4 lines)
                buildLabel("Address"),
                TextFormField(
                  controller: addressController,
                  maxLines: 4,
                  decoration: style("Address"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 35),
                //  Save button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSubmitted = true;
                        countryError = userController.countryCode.value.isEmpty
                            ? "Select country code"
                            : null;
                      });

                      if (!_formKey.currentState!.validate() ||
                          countryError != null) {
                        return;
                      }
                      // PROFILE IMAGE VALIDATION

                      if (userController.userImage.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile image is required"),
                          ),
                        );

                        return;
                      }

                      userController.phone.value = phoneController.text;

                      userController.address.value = addressController.text;

                      await userController.saveProfile();

                      Get.snackbar("Success", "Profile Saved");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // cleaner look
                      ),
                    ),
                    child: const Text(
                      "Save Profile",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
