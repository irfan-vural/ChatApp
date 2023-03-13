import 'dart:io';

import 'package:comrades/const/constants.dart';
import 'package:comrades/pages/home_page.dart';
import 'package:comrades/service/auth_service.dart';
import 'package:comrades/widget/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

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

  final picker = ImagePicker();
  File? image;
  bool isDefaultImage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Profile"),
          actions: [
            Icon(Icons.dark_mode),
            Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: ValueListenableBuilder(
              valueListenable: Hive.box('settings').listenable(),
              builder: (context, box, child) {
                final isDark = box.get('isDark', defaultValue: false);
                return Switch(
                  value: isDark,
                  onChanged: (val) {
                    box.put('isDark', val);
                  },
                );
              },
            ))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                height: 200,
                child: CircleAvatar(
                    backgroundImage: isDefaultImage
                        ? NetworkImage(Constants.src)
                        : Image.file(image!).image),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                widget.userName,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
              )),
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
                          content:
                              const Text("Are you sure you want to logout?"),
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
                                        builder: (context) =>
                                            const LoginPage()),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              child: CircleAvatar(
                backgroundImage: NetworkImage(Constants.src),
              ),
            ),
            ElevatedButton(
                onPressed: () => _onClick(), child: Text("Change Profile Pic")),
            SizedBox(height: 40),
            ProfileTile(
                icon: Icon(Icons.person),
                title: widget.userName,
                subtitle: widget.email),
            ProfileTile(
                icon: Icon(Icons.info),
                title: "About",
                subtitle: "Hey there! I am using Comrades"),
            ProfileTile(
                icon: Icon(Icons.phone),
                title: "Phone",
                subtitle: "1234567890"),
          ],
        ));
  }

  Future _onClick() async {
    final XFile ximage = picker.pickImage(source: ImageSource.gallery) as XFile;

    setState(() {
      image = File(ximage.path);
      isDefaultImage = false;
    });
  }
}
