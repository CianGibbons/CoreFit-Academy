import 'package:corefit_academy/main.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:corefit_academy/components/logo_with_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                print("Username: " + username);
                print("Password: " + password);
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
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('Sign Up!'),
              ),
            ],
          ),
        ],
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
