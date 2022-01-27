import 'package:corefit_academy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:corefit_academy/components/logo_with_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:corefit_academy/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  // if i wanted to be able to pass int into the login page when navigating
  // final int value;
  // const LoginPage(this.value, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  String errorMessage = "";
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWithText(
                  tag: 'logo',
                  logoCircleWidth: 130.0,
                  logoCircleHeight: 130.0,
                  logoIconSize: 100,
                  logoTextFontSize: 30.0,
                ),
                CustomInputTextField(
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.person_outline,
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
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        //Go to home page
                        // Navigator.pushNamed(context, '/home');
                        Navigator.popAndPushNamed(context, '/home');
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                          errorMessage = e.toString();
                        });
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not registered yet?'),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/signup');
                      },
                      child: const Text('Sign Up!'),
                    ),
                  ],
                ),
              ],
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
