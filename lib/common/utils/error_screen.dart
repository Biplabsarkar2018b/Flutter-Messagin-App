import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  final String st;
  const ErrorScreen({super.key, required this.error, required this.st});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Text(
                  error.toString(),
                  style: TextStyle(color: Colors.red, fontSize: 21),
                ),
                Text(
                  st.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
