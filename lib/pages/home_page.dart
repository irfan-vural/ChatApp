import 'package:comrades/helper/helper_functions.dart';
import 'package:comrades/pages/search_page.dart';
import 'package:comrades/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/auth_service.dart';
import '../service/database_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _backButtonPressed(context),
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    nextScreen(context, SearchPage());
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              SizedBox(width: 20),
            ],
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Comrades'),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 20),
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {},
            child: Icon(Icons.message),
          )),
    );
  }

  Future<bool> _backButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                  onPressed: () => nextScreen(context, HomePage()),
                  child: Text('No')),
              TextButton(
                  onPressed: () => SystemNavigator.pop(), child: Text('Yes')),
            ],
          );
        });
    throw UnimplementedError();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }
}
