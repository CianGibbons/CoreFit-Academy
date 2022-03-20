import 'package:flutter/material.dart';

class DayRepresentation extends StatelessWidget {
  const DayRepresentation(
      {Key? key,
      required this.workoutPresent,
      required this.dayValue,
      required this.dayReached})
      : super(key: key);
  final bool workoutPresent;
  final bool dayReached;
  final int dayValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(getDayShort()),
          Icon(
            dayReached
                ? (workoutPresent ? Icons.done : Icons.clear)
                : Icons.more_time,
            color: dayReached
                ? (workoutPresent ? Colors.green : Colors.red)
                : Colors.white60,
          ),
        ],
      ),
    );
  }

  String getDayShort() {
    String dayShort = "MON";
    switch (dayValue) {
      case 2:
        dayShort = "TUE";
        break;
      case 3:
        dayShort = "WED";
        break;
      case 4:
        dayShort = "THUR";
        break;
      case 5:
        dayShort = "FRI";
        break;
      case 6:
        dayShort = "SAT";
        break;
      case 7:
        dayShort = "SUN";
        break;
    }
    return dayShort;
  }
}
