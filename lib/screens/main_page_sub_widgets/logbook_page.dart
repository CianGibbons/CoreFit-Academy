import 'package:flutter/material.dart';

class LogBook extends StatefulWidget {
  const LogBook({Key? key}) : super(key: key);

  @override
  _LogBookState createState() => _LogBookState();
}

class _LogBookState extends State<LogBook> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
