import 'dart:io';

import 'package:comrades/service/auth_service.dart';
import 'package:comrades/widget/widgets.dart';
import 'package:flutter/material.dart';

import '../pages/auth/login_page.dart';
import '../pages/profile_page.dart';

class DrawerTile extends StatefulWidget {
  final String userName;
  final String email;
  final File image;
  const DrawerTile(
      {Key? key,
      required this.userName,
      required this.email,
      required this.image})
      : super(key: key);

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 50),
      children: <Widget>[
        Container(
          height: 200,
          child: CircleAvatar(
            backgroundImage: Image.file(widget.image).image,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          widget.userName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[300],
          ),
          child: ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            nextScreen(
                context,
                ProfilePage(
                  userName: widget.userName,
                  email: widget.email,
                  image: widget.image,
                ));
          },
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: const Icon(Icons.person),
          title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
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
                          await AuthService().signOut();
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
        )
      ],
    ));
  }
}
