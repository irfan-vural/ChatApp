import 'dart:io';

import 'package:comrades/const/constants.dart';
import 'package:comrades/helper/helper_functions.dart';
import 'package:comrades/pages/home_page.dart';
import 'package:comrades/service/auth_service.dart';
import 'package:comrades/widget/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(
      {required this.userName, required this.email, required this.image});
  final String userName;
  final String email;
  @override
  File? image = File(Constants.src);

  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.secondarycolor,
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
          backgroundColor: Constants.secondarycolor,
          child: ListView(
            children: [
              Container(
                height: 200,
                child: CircleAvatar(
                    backgroundImage: Image.file(widget.image!).image),
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
              height: 200,
              child: CircleAvatar(
                backgroundImage: Image.file(widget.image!).image,
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                onPressed: () => popUpDialog(context),
                child: Text("Change Profile Pic")),
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

  Future<File?> _onClick(ImageSource source) async {
    final XFile? ximage = await picker.pickImage(source: source) as XFile;
    if (ximage == null) {
      return null;
    }

    setState(() {
      widget.image = File(ximage.path);
      HelperFunctions.saveUserProfilePicSF(ximage.path);
    });
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              actionsOverflowButtonSpacing: 12,
              actionsOverflowDirection: VerticalDirection.down,
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              title: Text(
                "Change Profile Pic",
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _onClick(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CHOOSE FROM GALLERY"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _onClick(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: Theme.of(context).primaryColor),
                  child: const Text("TAKE A PICTURE"),
                )
              ],
            );
          }));
        });
  }
}
