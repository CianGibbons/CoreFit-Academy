import 'package:corefit_academy/main.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:corefit_academy/components/logo_with_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  //If I want to pass in an int parameter into the signup page upon navigation
  // final int value;
  // const SignUpPage(this.value, {Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;

  String _displayName = "";
  String _email = "";
  String _password = "";
  String _confirmedPassword = "";

  String errorMessage = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWithText(
                    tag: 'logo',
                    logoCircleWidth: 100.0,
                    logoCircleHeight: 100.0,
                    logoIconSize: 70,
                    logoTextFontSize: 20.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomInputTextField(
                    textInputType: TextInputType.text,
                    iconData: Icons.tag_faces_outlined,
                    inputLabel: "Display Name",
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        _displayName = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomInputTextField(
                    textInputType: TextInputType.emailAddress,
                    iconData: Icons.email_outlined,
                    inputLabel: "Email",
                    obscureText: false,
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomInputTextField(
                    textInputType: TextInputType.text,
                    iconData: Icons.lock_outline,
                    inputLabel: "Password",
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomInputTextField(
                    textInputType: TextInputType.text,
                    iconData: Icons.lock_outline,
                    inputLabel: "Confirm Password",
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _confirmedPassword = value;
                      });
                    },
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        errorMessage,
                        style: kErrorMessage,
                      )),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (_displayName == "") {
                          errorMessage =
                              "Display Name Field must not be left blank.";
                        } else if (_email == "") {
                          //Notify that Both Password Fields must match
                          errorMessage = "Email Field must not be left blank.";
                        } else if (_password == _confirmedPassword) {
                          try {
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                            if (newUser != null) {
                              //Set DisplayName
                              await _auth.currentUser!
                                  .updateDisplayName(_displayName);

                              //Go to home page
                              Navigator.pushNamed(context, "/home");
                            }
                          } catch (e) {
                            errorMessage = e.toString();
                          }
                        } else {
                          //Notify that Both Password Fields must match
                          errorMessage =
                              "Both the Password and Confirm Password Fields must be equal!";
                        }
                        //update the errorMessage/hide spinner
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          // Authenticating the user and removing this page from the stack
                          // This removes the back button from the app bar on the home page.
                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, '/login', (_) => false);
                          Navigator.popAndPushNamed(context, '/login');
                        },
                        child: const Text('Log In!'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: Colors.grey.shade300,
              onPressed: () {
                ThemeController.setTheme(context, Themes().lightTheme);
              }),
          FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.grey.shade800,
              onPressed: () {
                ThemeController.setTheme(context, Themes().darkTheme);
              }),
        ],
      ),
    );
  }
}
