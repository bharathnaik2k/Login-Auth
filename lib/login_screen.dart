import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  login() {
   void login1() async {
      var url = "'https://dummyjson.com/auth/login'";
      var uri = Uri.parse(url);
      var body = {
        "username": username.text.trim(),
        "password": password.text.trim(),
      };
      var response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
     
    }
    // return login1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: username,
              decoration: const InputDecoration(hintText: "Username"),
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(hintText: "Password"),
            ),
            TextButton(onPressed: () {}, child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
