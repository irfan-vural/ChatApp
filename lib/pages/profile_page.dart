import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({required this.userName, required this.email});
  final String userName;
  final String email;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
