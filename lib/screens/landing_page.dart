import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  // If I wanted to pass in an int to this page upon Navigation, would need to
  // use onGeneralRoute in MaterialApp
  // final int value;
  // const LandingPage(this.value, {Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  void getCurrentUser() {
    final User user = _auth.currentUser!;

    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoreFit Academy'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            const Text('Hello'),
            ElevatedButton(
              onPressed: getCurrentUser,
              child: const Text('Get Current User'),
            ),
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
                    print(e);
                  }
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
