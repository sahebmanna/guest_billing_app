//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
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

            // PROFILE
            ListTile(
              leading: const Icon(Icons.person),

              title: const Text("Profile"),

              onTap: () {
                Get.offNamed('/ProfilePage');
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

                  Get.toNamed('/guestDetails');
                },
              ),
            ),
          ],
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              // PROFILE IMAGE
              CircleAvatar(
                radius: 60,

                backgroundImage: userController.userImage.value != null
                    ? FileImage(userController.userImage.value!)
                    : null,

                child: userController.userImage.value == null
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
                      buildTile("First Name", userController.firstName.value),

                      buildTile("Last Name", userController.lastName.value),

                      buildTile("Email", userController.email.value),

                      buildTile("Gender", userController.gender.value),

                      buildTile(
                        "Phone",
                        "${userController.countryCode.value} "
                            "${userController.phone.value}",
                      ),

                      buildTile(
                        "DOB",

                        userController.dob.value.isEmpty
                            ? ""
                            : "${DateTime.parse(userController.dob.value).day}/"
                                  "${DateTime.parse(userController.dob.value).month}/"
                                  "${DateTime.parse(userController.dob.value).year}",
                      ),

                      buildTile("Address", userController.address.value),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
