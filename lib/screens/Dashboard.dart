//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: Get.find<UserController>(),

      builder: (userController) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Dashboard"),
          ),

          // RIGHT DRAWER
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

                // PROFILE
                ListTile(
                  leading: const Icon(Icons.person),

                  title: const Text("Profile"),

                  onTap: () {
                    Get.toNamed('/ProfilePage');
                  },
                ),

                // DASHBOARD
                ListTile(
                  leading: const Icon(Icons.dashboard),

                  title: const Text("Dashboard"),

                  onTap: () {
                    Navigator.pop(context);
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

                    Get.toNamed('/guestDetails');
                  },
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                const SizedBox(height: 20),

                // PROFILE IMAGE
                CircleAvatar(
                  radius: 60,

                  backgroundImage: userController.userImage != null
                      ? FileImage(userController.userImage!)
                      : null,

                  child: userController.userImage == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),

                const SizedBox(height: 25),

                // USER INFO CARD
                Card(
                  elevation: 5,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [
                        buildTile("First Name", userController.firstName),

                        buildTile("Last Name", userController.lastName),

                        buildTile("Email", userController.email),

                        buildTile("Gender", userController.gender),

                        buildTile(
                          "Phone",
                          "${userController.countryCode} "
                              "${userController.phone}",
                        ),

                        buildTile(
                          "DOB",

                          userController.dob.isEmpty
                              ? ""
                              : "${DateTime.parse(userController.dob).day}/"
                                    "${DateTime.parse(userController.dob).month}/"
                                    "${DateTime.parse(userController.dob).year}",
                        ),

                        buildTile("Address", userController.address),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 120,

            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
