import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrades/helper/helper_functions.dart';
import 'package:comrades/pages/home_page.dart';
import 'package:comrades/pages/register_page.dart';
import 'package:comrades/service/auth_service.dart';
import 'package:comrades/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../const/constants.dart';
import '../service/database_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;

  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Comrades", style: Constants.header1Style),
                          SizedBox(height: 20),
                          Text("Join your comrades and start chatting",
                              style: Constants.header2Style),
                          //  Image.asset('assets/login_image.jpg'),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            onChanged: (value) {
                              password = value;
                              print(password);
                            },
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  login();
                                },
                                child: Text(
                                  'Login',
                                  style: Constants.loginButtonStyle,
                                )),
                          ),
                          SizedBox(height: 20),
                          Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        nextScreen(context, RegisterPage());
                                      });
                                    },
                                  text: "Sign Up",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ));
  }

  login() async {
    var isUserExist = await HelperFunctions.isUserExists(email);
    if (_formKey.currentState!.validate() & isUserExist) {
      setState(() {
        _isLoading = true;
      });
      _authService
          .loginWithUserNameandPassword(email.trim(), password.trim())
          .then((value) async {
        if (value != null) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          nextScreen(context, HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
        }
      });
    }
  }
}
