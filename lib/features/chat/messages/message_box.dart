import 'package:flutter/material.dart';

Widget sentMessage(BuildContext context, String text) {
  final size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.all(size.width*0.004),
    decoration: const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    ),
    child: Text(text,style: const TextStyle(color: Colors.white),),
  );
}

Widget recievedMessage(BuildContext context, String text) {
  final size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.all(size.width*0.004),
    decoration: const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    ),
    child: Text(text,style: const TextStyle(color: Colors.white),),
  );
}
