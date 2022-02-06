import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/main.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:corefit_academy/utilities/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                const Text(kThemeSettingsName),
                CustomElevatedButton(
                  onPressed: () {
                    ThemeController.setTheme(context, Themes().darkTheme);
                  },
                  child: const Text(kThemeDarkName),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    ThemeController.setTheme(context, Themes().lightTheme);
                  },
                  child: const Text(kThemeLightName),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
            Column(
              children: const [
                SignOutButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
