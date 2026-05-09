import 'package:flutter/material.dart';
import 'RegisterPage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();

  final userController = Get.find<UserController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool _isSubmitted = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadRememberedUser();
  }

  Future<void> login() async {
    setState(() {
      _isSubmitted = true; // enable validation only after click
    });

    if (!_formKey.currentState!.validate()) {
      return; // shows required/format errors
    }

    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString("email");
    final savedPassword = prefs.getString("password");

    final email = emailController.text;
    final password = passwordController.text;

    if (email != savedEmail || password != savedPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Wrong email or password")));
      return;
    }

    print("Email: $email");
    print("Password: $password");

    if (rememberMe) {
      await prefs.setBool("rememberMe", true);
      await prefs.setString("rememberEmail", emailController.text);
      await prefs.setString("rememberPassword", passwordController.text);
    } else {
      await prefs.setBool("rememberMe", false);
      await prefs.remove("rememberEmail");
      await prefs.remove("rememberPassword");
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Login Successful")));
    //await userController.loadUserData();

    Get.offNamed('/ProfilePage');
    //Navigator.pushReplacementNamed(context, '/Dashboard');
  }

  Future<void> loadRememberedUser() async {
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString("rememberEmail");
    final savedPassword = prefs.getString("rememberPassword");
    final isRemembered = prefs.getBool("rememberMe") ?? false;

    if (isRemembered) {
      setState(() {
        rememberMe = true;
        emailController.text = savedEmail ?? "";
        passwordController.text = savedPassword ?? "";
      });
    }
  }

  /*@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: _isSubmitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Center(child: Icon(Icons.account_circle, size: 60)),
                ),
                SizedBox(height: 10),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const Text("Email"),
                      const SizedBox(height: 6),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: "your@email.com",
                          labelText: "email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          final gmailRegex = RegExp(
                            r"^[a-zA-Z0-9._%+-]+@gmail\.com$",
                          );
                          if (!gmailRegex.hasMatch(value)) {
                            return "Enter a valid email (example@gmail.com)";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Password'),
                      TextFormField(
                        controller: passwordController,
                        obscuringCharacter: '*',
                        obscureText: !passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: "••••••••",
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password required";
                          }
                          if (value.length < 8) {
                            return "Min 8 characters";
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              const Text("Remember Me"),
                            ],
                          ),

                          TextButton(
                            onPressed: () {
                              // Handle forgot password action
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),

                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // 🔥 square corners
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 13,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, '/signup');
                        // Navigator.pushNamed(context, '/signup');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },

                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
