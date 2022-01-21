import 'package:corefit_academy/main.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:corefit_academy/components/logo_with_text.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String username = "";
  String email = "";
  String password = "";
  String confirmedPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LogoWithText(
                  logoCircleWidth: 130.0,
                  logoCircleHeight: 130.0,
                  logoIconSize: 100,
                  logoTextFontSize: 30.0,
                ),
                CustomInputTextField(
                  textInputType: TextInputType.text,
                  iconData: Icons.person_outline,
                  inputLabel: "Username",
                  obscureText: false,
                  onChanged: (value) {
                    setState(() {
                      username = value;
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
                      email = value;
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
                      password = value;
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
                      confirmedPassword = value;
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      print('Username: ' + username);
                      print('Password: ' + password);
                      print('Confirmed Password: ' + confirmedPassword);
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
                        Navigator.pushNamed(context, '/login');
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              backgroundColor: Colors.grey.shade300,
              onPressed: () {
                ThemeController.setTheme(context, Themes().lightTheme);
              }),
          FloatingActionButton(
              backgroundColor: Colors.grey.shade800,
              onPressed: () {
                ThemeController.setTheme(context, Themes().darkTheme);
              }),
        ],
      ),
    );
  }
}
