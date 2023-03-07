import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  var email;

  HomeScreen({super.key, required this.email});

 

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Welcome $email"),),
    );
  }
}
