import 'package:comrades/widget/widgets.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('homepage'),
      ),
      body: ElevatedButton(
          onPressed: () {
            AuthService().signOut();
            nextScreen(context, LoginPage());
          },
          child: Text('logout')),
    );
  }
}
