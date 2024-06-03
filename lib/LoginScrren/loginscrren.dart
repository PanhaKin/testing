import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app_login/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse('https://hrm.hellodesk.app/api/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Ensure role is a list
      List<String> roles = [];
      if (responseData['role'] is List) {
        roles = List<String>.from(responseData['role']);
      } else if (responseData['role'] is String) {
        roles = responseData['role'].split(','); // Adjust based on how roles are formatted
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', responseData['email']);
      await prefs.setString('uid', responseData['uid']);
      await prefs.setString('username', responseData['username']);
      await prefs.setString('access_token', responseData['access_token']);
      await prefs.setString('profileImg', responseData['profileImg']);
      await prefs.setStringList('role', roles);

      print('Login successful: $responseData');
      Get.to(HomePage());
    } else {
      print('Login failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: login,
              child: Container(
                height: 30,
                width: double.infinity,
                color: Colors.pink,
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
