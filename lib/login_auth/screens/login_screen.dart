import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_auth/login_auth/api/api_address.dart';
import 'package:login_auth/login_auth/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool circleProgress = false;

  alertdailog(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 10),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(
                  Colors.blue,
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          title: const Icon(Icons.warning_rounded),
        );
      },
    );
  }

  Future<void> fecthdata(String token) async {
    String url = fecthdataUrl;
    Uri uri = Uri.parse(url);
    dynamic response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    dynamic userdata = jsonDecode(response.body);
    setState(() {
      circleProgress = false;
    });
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

  Future<void> login() async {
    try {
      String url = loginUrl;
      Uri uri = Uri.parse(url);
      dynamic response = await http.post(
        uri,
        body: jsonEncode({
          "username": username.text.trim(),
          "password": password.text.trim(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
      dynamic rbody = jsonDecode(response.body);
      String token = rbody["accessToken"].toString();

      if (token == "null") {
        alertdailog("Invaild Username or Password");
        setState(() {
          circleProgress = false;
        });
      } else {
        fecthdata(token);
      }
    } on TimeoutException {
      setState(() {
        circleProgress = false;
      });
      var snackBar = const SnackBar(content: Text('Timeout'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on SocketException {
      setState(() {
        circleProgress = false;
      });
      var snackBar = const SnackBar(content: Text('No Internet'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Error catch (e) {
      log(e.toString());
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
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade500),
                hintText: "Username",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: password,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade500),
                hintText: "Password",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              style: ButtonStyle(
                minimumSize: const MaterialStatePropertyAll(Size(160, 45)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                backgroundColor: circleProgress == true
                    ? const MaterialStatePropertyAll(
                        Color.fromARGB(255, 130, 199, 255))
                    : const MaterialStatePropertyAll(Colors.blue),
              ),
              onPressed: () {
                if (circleProgress == false) {
                  setState(() {
                    if (username.text.isEmpty && password.text.isEmpty) {
                      alertdailog("Fill The Details");
                    } else if (username.text.isEmpty) {
                      alertdailog("Fill The Username");
                    } else if (password.text.isEmpty) {
                      alertdailog("Fill The Password");
                    } else {
                      login();
                      circleProgress = true;
                    }
                  });
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: circleProgress == true
                  ? const SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
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
