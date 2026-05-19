import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:get/get.dart';
import '../controllers/user_controller.dart';

import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final dobController = TextEditingController();

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

    phoneController.text = userController.phone;

    addressController.text = userController.address;

    if (userController.dob.isNotEmpty) {
      dobController.text = formatDate(userController.dob);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final img = await _picker.pickImage(source: source);

    if (img != null) {
      userController.setUserImage(File(img.path));
    }

    userController.imageError = null;

    userController.update();
  }

  Future<void> pickDOB() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: userController.dob.isNotEmpty
          ? DateTime.parse(userController.dob)
          : DateTime(2000),

      firstDate: DateTime(1900),

      lastDate: DateTime.now(),
    );

    if (picked != null) {
      await userController.pickDOB(picked);
      dobController.text = formatDate(userController.dob);
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

  String formatDate(String dob) {
    try {
      final date = DateTime.parse(dob);

      return "${date.day}-"
          "${date.month}-"
          "${date.year}";
    } catch (e) {
      return "";
    }
  }

  @override
  void dispose() {
    phoneController.dispose();

    addressController.dispose();
    dobController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: Get.find<UserController>(),

      builder: (userController) {
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
                  accountName: Text(
                    "${userController.firstName} "
                    "${userController.lastName}",
                  ),

                  accountEmail: Text(userController.email),

                  currentAccountPicture: CircleAvatar(
                    backgroundImage: userController.userImage != null
                        ? FileImage(userController.userImage!)
                        : null,

                    child: userController.userImage == null
                        ? const Icon(Icons.person)
                        : null,
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
                ListTile(
                  leading: Icon(
                    Icons.dashboard,

                    color: userController.isProfileComplete
                        ? Colors.black
                        : Colors.grey,
                  ),

                  title: Text(
                    "API Photo Gallary",

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

                // GUEST DETAILS
                ListTile(
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
              ],
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: userController.isSubmitted
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

                        backgroundColor: Colors.grey.shade200,

                        backgroundImage: userController.userImage != null
                            ? FileImage(userController.userImage!)
                            : null,

                        child: userController.userImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: const [
                                  Icon(
                                    Icons.person,
                                    size: 45,
                                    color: Colors.grey,
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    "Upload\nProfile Image",

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
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

                  const SizedBox(height: 10),

                  if (userController.imageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),

                      child: Text(
                        userController.imageError!,

                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Name (read only)
                  buildLabel("First Name"),

                  TextField(
                    readOnly: true,
                    decoration: style(userController.firstName),
                  ),
                  const SizedBox(height: 4),
                  buildLabel("Last Name"),
                  TextField(
                    readOnly: true,
                    decoration: style(userController.lastName),
                  ),

                  const SizedBox(height: 4),
                  //Gender dropdown
                  buildLabel("Gender"),

                  DropdownButtonFormField<String>(
                    initialValue: userController.gender == ""
                        ? null
                        : userController.gender,
                    hint: const Text("Select Gender"),
                    items: ["Male", "Female", "Other"]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (val) {
                      userController.gender = val!;
                      userController.update();
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
                    decoration: style(userController.email),
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
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: userController.countryCode,
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
                                userController.countryCode = val!;
                                //userController.update();
                                userController.countryError = null;

                                userController.update();
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,

                                LengthLimitingTextInputFormatter(10),
                              ],
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

                      if (userController.countryError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            userController.countryError!,
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
                  /* TextField(
                    readOnly: true,
                    onTap: pickDOB,
                    decoration: style("Date of Birth").copyWith(
                      hintText: userController.dob.isEmpty
                          ? "Select Date"
                          : "${DateTime.parse(userController.dob).day}/${DateTime.parse(userController.dob).month}/${DateTime.parse(userController.dob).year}",
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  */
                  TextField(
                    controller: dobController,

                    readOnly: true,

                    onTap: pickDOB,

                    decoration: style(
                      "Date of Birth",
                    ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                  ),

                  const SizedBox(height: 24),

                  //  Address (3–4 lines)
                  buildLabel("Address"),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
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
                        userController.isSubmitted = true;

                        userController.countryError =
                            userController.countryCode.isEmpty
                            ? "Select country code"
                            : null;

                        userController.update();

                        if (!_formKey.currentState!.validate() ||
                            userController.countryError != null) {
                          return;
                        }
                        // PROFILE IMAGE VALIDATION

                        /* // if (userController.userImage == null) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text("Profile image is required"),
                        //     ),
                        //   );

                        //   return;
                        // }
                        */
                        if (userController.userImage == null) {
                          userController.imageError = "Upload profile image";

                          userController.update();

                          return;
                        } else {
                          userController.imageError = null;
                        }

                        userController.phone = phoneController.text;

                        userController.address = addressController.text;

                        await userController.saveProfile();

                        Get.snackbar("Success", "Profile Saved");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ), // cleaner look
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
        );
      },
    );
  }
}
