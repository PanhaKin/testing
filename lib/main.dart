import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_app_login/LoginScrren/loginscrren.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen()
    );
  }
}
