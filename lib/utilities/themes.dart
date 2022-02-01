import 'package:flutter/material.dart';

class Themes {
  ThemeData get darkTheme => ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green.shade800,
          secondary: Colors.lightGreen.shade500,
          onBackground: Colors.grey.shade600,
          onSurface: Colors.grey.shade400,
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
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      );

  ThemeData get lightTheme => ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green.shade800,
          secondary: Colors.green.shade700,
          onBackground: Colors.grey.shade500,
          onSurface: Colors.grey.shade200,
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
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      );
}
