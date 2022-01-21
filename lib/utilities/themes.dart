import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Themes {
  ThemeData get darkTheme => ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.lightGreen.shade500,
          onBackground: Colors.grey.shade600,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.lightGreen.shade500.withOpacity(0.5);
                }
                return Colors
                    .lightGreen.shade500; // Use the component's default.
              },
            ),
          ),
        ),
      );

  ThemeData get lightTheme => ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green.shade700,
          onBackground: Colors.grey.shade400,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.lightGreen.shade700.withOpacity(0.5);
                }
                return Colors
                    .lightGreen.shade700; // Use the component's default.
              },
            ),
          ),
        ),
      );
}
