import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/screens/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'components/logo_with_text.dart';

class AuthController extends StatelessWidget {
  const AuthController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    AuthAction pageAction = AuthAction.signIn;
    return StreamBuilder<User?>(
        // getting logged in user and if its null we know that the user is not logged in
        // listening for the state change of the logged in user and passing it in through
        // snapshot
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // if the user is not logged in, send to the Login Screen
            return SignInScreen(
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId:
                      "265698258465-citah9bdshi2bbj9r9bpffsil352bvjd.apps.googleusercontent.com",
                )
              ],
              headerBuilder: (context, constraints, _) {
                return const FittedBox(
                  child: LogoWithText(
                    tag: 'logo',
                    logoCircleWidth: 100.0,
                    logoCircleHeight: 100.0,
                    logoIconSize: 70,
                    logoTextFontSize: 20.0,
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                pageAction = action;
                return Text(action == AuthAction.signIn
                    ? "Sign into your account below!"
                    : "Sign Up to CoreFit Academy below!");
              },
            );
          }

          // Saving user email and uId to the data base to allow the viewers
          // functionality to work
          User _current = snapshot.data!;
          if (pageAction == AuthAction.signUp) {
            _firestore.collection('users').add({
              'userId': _current.uid,
              'email': _current.email,
            });
          }
          return NavigationController(user: _current);
        });
  }
}
