import 'package:comrades/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../const/constants.dart';
import '../helper/helper_functions.dart';
import '../widget/widgets.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  bool _isLoading = false;
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _isLoading
            ? Center(child: Center(child: CircularProgressIndicator()))
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
                          Text("Create your account comrade",
                              style: Constants.header2Style),
                          SizedBox(height: 20),
                          //  Image.asset('assets/login_image.jpg'),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Full Name",
                              prefixIcon: Icon(Icons.email),
                            ),
                            onChanged: (value) {
                              name = value;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your full name";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
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
                                  signUp();
                                },
                                child: Text(
                                  'Sign Up',
                                  style: Constants.loginButtonStyle,
                                )),
                          ),
                        ],
                      )),
                ),
              ));
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
    }
    await authService
        .registerUserWithEmailAndPassword(
            name.trim(), email.trim(), password.trim())
        .then((value) async {
      if (value == true) {
        //  await HelperFunctions.saveUserLoggedInStatus(true);
        // await HelperFunctions.saveUserEmailSF(email);
        // await HelperFunctions.saveUserNameSF(fullName);
        nextScreen(context, const HomePage());
      } else {
        showSnackbar(context, Colors.red, value.toString());
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
