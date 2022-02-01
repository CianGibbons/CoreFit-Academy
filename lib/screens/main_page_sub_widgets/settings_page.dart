import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/main.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

//TODO: Style Settings Page and add more settings - Maybe Change Display Name
class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Text('Themes'),
                CustomElevatedButton(
                  onPressed: () {
                    ThemeController.setTheme(context, Themes().darkTheme);
                  },
                  child: const Text('Dark'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    ThemeController.setTheme(context, Themes().lightTheme);
                  },
                  child: const Text('Light'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            CustomElevatedButton(
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
              backgroundColor: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
      ),
    );
  }
}
