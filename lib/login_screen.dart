import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  alertdailog(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text),
            ],
          ),
          title: const Icon(Icons.warning_rounded),
        );
      },
    );
  }

  void fecthdata(String token) async {
    String url = 'https://dummyjson.com/auth/me';
    Uri uri = Uri.parse(url);
    dynamic response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    dynamic userdata = jsonDecode(response.body);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen(
            userdata: userdata,
          );
        },
      ),
    );
  }

  void login() async {
    String url = "https://dummyjson.com/auth/login";
    Uri uri = Uri.parse(url);
    Map<String, dynamic> body = {
      "username": username.text.trim(),
      "password": password.text.trim(),
    };
    dynamic response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    dynamic rbody = jsonDecode(response.body);
    String token = rbody["accessToken"].toString();

    if (token == "null") {
      alertdailog("Invaild Username or Password");
    } else {
      fecthdata(token);
    }
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
            const Icon(Icons.login, size: 75),
            const SizedBox(height: 30),
            TextField(
              controller: username,
              decoration: const InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                backgroundColor: const MaterialStatePropertyAll(Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  if (username.text.isEmpty && password.text.isEmpty) {
                    alertdailog("Fill The Username And Password");
                  } else if (username.text.isEmpty) {
                    alertdailog("Fill The Username");
                  } else if (password.text.isEmpty) {
                    alertdailog("Fill The Password");
                  } else {
                    login();
                  }
                });
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
