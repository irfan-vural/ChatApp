import 'package:flutter/material.dart';

class Constants {
  static final primarycolor = Colors.green[900]!;
  static String src =
      "https://fastly.picsum.photos/id/525/200/300.jpg?hmac=Dhg6JV7Cl1oDtYMG0pq3hVUbGQjEpOX41178aR7_eh8";

  static TextStyle header1Style =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  static TextStyle header2Style =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w400);

  static TextStyle loginButtonStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  static InputDecoration popUpInputDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)));
}
