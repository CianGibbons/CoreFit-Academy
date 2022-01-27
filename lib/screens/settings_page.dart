import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:corefit_academy/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

//TODO: Style Settings Page and add more settings - Maybe Change Display Name
class _SettingsPageState extends State<SettingsPage> {
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
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    ThemeController.setTheme(context, Themes().darkTheme);
                  },
                  child: const Text('Dark'),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    ThemeController.setTheme(context, Themes().lightTheme);
                  },
                  child: const Text('Light'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
