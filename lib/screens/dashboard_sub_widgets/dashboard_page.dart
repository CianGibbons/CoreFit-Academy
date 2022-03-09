import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: Column(
          children: const [
            //TODO: Monitor Workout Progress and Record Data -> Visualise this Data
            //TODO: Implement the use of Location Data to monitor exercises routes -> Visual Representation
            //TODO: Set Goals for each Week/Month/Year -> Different Types of Goals - Muscle Build-up, Weight Gain/Loss, Distance for a Run, etc
          ],
        ),
      ),
    );
  }
}
