import 'package:comrades/const/constants.dart';
import 'package:comrades/pages/home_page.dart';
import 'package:comrades/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({required this.userName, required this.email});
  final String userName;
  final String email;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Profile"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 200,
              child: CircleAvatar(
                backgroundImage: NetworkImage(Constants.src),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[300],
              ),
              child: ListTile(
                iconColor: Colors.red,
                leading: Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.group),
              title: const Text("Groups"),
              onTap: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return HomePage();
                  },
                ), (route) => false);
              },
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(Constants.src),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    "User Name",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(widget.userName, style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(widget.email, style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
