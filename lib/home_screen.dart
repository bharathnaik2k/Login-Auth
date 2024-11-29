import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  var userdata;
  HomeScreen({super.key, required this.userdata});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loged in"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(),
            child: Image.network(widget.userdata['image']),
          ),
          Text("Username : ${widget.userdata["username"]}"),
        ],
      ),
    );
  }
}
