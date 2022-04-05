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
import 'package:corefit_academy/controllers/theme_controller.dart';

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
