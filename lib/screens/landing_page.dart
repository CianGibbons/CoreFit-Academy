import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoreFit Academy'),
      ),
      body: Column(
        children: [
          Text('Hello '),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pushNamed(context, "/login");
                } catch (e) {
                  print(e);
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
