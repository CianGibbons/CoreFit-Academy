import 'package:corefit_academy/firebase_options.dart';
import 'package:corefit_academy/controllers/auth_controller.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:corefit_academy/utilities/providers/valid_workout_selected_provider.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ErrorMessageStringProvider()),
    ChangeNotifierProvider(create: (_) => DurationSelectedProvider()),
    ChangeNotifierProvider(create: (_) => ValidWorkoutSelectedBoolProvider()),
  ], child: const CoreFitAcademy()));
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
          home: const AuthController(),
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
