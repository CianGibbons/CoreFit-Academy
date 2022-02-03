import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogBook extends StatelessWidget {
  const LogBook({Key? key, required this.user}) : super(key: key);
  final User user;
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
