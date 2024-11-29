import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userdata;
  const HomeScreen({super.key, required this.userdata});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Login Auth",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueAccent.shade700,
              height: 60,
              width: 60,
              child: Image.network(widget.userdata['image']),
            ),
            Text("Username : ${widget.userdata["username"]}"),
            Text(
              "${widget.userdata['firstName']} ${widget.userdata['lastName']}",
              style: const TextStyle(fontSize: 22),
            ),
            Text(
              "${widget.userdata['phone']}",
            ),
            Text(
              "${widget.userdata['address']['address']}",
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
