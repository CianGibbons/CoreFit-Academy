import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _auth = FirebaseAuth.instance;

  String testString = "";
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  setState(() {
                    showSpinner = true;
                  });
                  await _auth.signOut();
                  // Navigator.pushNamed(context, '/login');
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (r) => false);
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  //TODO: Decide what to do with failed logout
                }
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
