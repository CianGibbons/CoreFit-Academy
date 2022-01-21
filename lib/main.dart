import 'package:corefit_academy/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'utilities/themes.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CoreFitAcademy());
}

class CoreFitAcademy extends StatelessWidget {
  const CoreFitAcademy({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeController(
      initialTheme: Themes().darkTheme,
      materialAppBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/login': (context) => const LoginPage(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/signup': (context) => const SignUpPage(),
          },
          home: const LoginPage(),
        );
      },
    );
  }
}

class ThemeController extends StatefulWidget {
  final ThemeData initialTheme;
  final MaterialApp Function(BuildContext context, ThemeData theme)
      materialAppBuilder;

  const ThemeController(
      {Key? key, required this.initialTheme, required this.materialAppBuilder})
      : super(key: key);

  @override
  _ThemeControllerState createState() => _ThemeControllerState();

  static void setTheme(BuildContext context, ThemeData theme) {
    var state = context.findAncestorStateOfType<_ThemeControllerState>()
        as _ThemeControllerState;

    state.currentTheme = theme;
    state.refresh();
  }
}

class _ThemeControllerState extends State<ThemeController> {
  late ThemeData currentTheme;

  @override
  void initState() {
    super.initState();
    currentTheme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    return widget.materialAppBuilder(context, currentTheme);
  }

  void refresh() {
    setState(() {});
  }
}
