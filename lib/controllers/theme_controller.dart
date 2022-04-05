import 'package:flutter/material.dart';

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
