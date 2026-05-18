import 'package:flutter/material.dart';

import 'package:task1_login_page_app/screens/Dashboard.dart';
import 'package:task1_login_page_app/screens/RegisterPage.dart';
import 'package:task1_login_page_app/screens/SplashScreen.dart';
import 'package:task1_login_page_app/screens/login.dart';
import 'package:task1_login_page_app/screens/guest_details_page.dart';
import 'package:task1_login_page_app/screens/ProfilePage.dart';

import 'package:task1_login_page_app/controllers/user_controller.dart';
import 'package:task1_login_page_app/controllers/guest_controller.dart';

import 'package:get/get.dart';

void main() {
  Get.put(GuestController(), permanent: true);
  Get.put(UserController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(color: Colors.red), // global error color
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const loginPage(),
        '/signup': (context) => const RegisterPage(),
        '/ProfilePage': (context) => const ProfilePage(),
        '/Dashboard': (context) => const DashboardPage(),
        '/guestDetails': (context) => const GuestDetailsPage(),
      },
    );
  }
}
