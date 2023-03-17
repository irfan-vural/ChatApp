import 'package:comrades/const/constants.dart';
import 'package:comrades/pages/home_page.dart';
import 'package:comrades/pages/auth/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'helper/helper_functions.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('settings');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  void getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, value, child) {
        final _isDark = value.get('isDark', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _isDark
              ? ThemeData.dark()
              : ThemeData.light()
                  .copyWith(primaryColor: Constants.primarycolor),
          home: _isSignedIn ? HomePage() : LoginPage(),
        );
      },
    );
  }
}
