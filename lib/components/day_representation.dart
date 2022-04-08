import 'package:flutter/material.dart';

class DayRepresentation extends StatelessWidget {
  const DayRepresentation({
    Key? key,
    required this.workoutPresent,
    required this.dayValue,
    required this.dayReached,
  }) : super(key: key);
  final bool workoutPresent;
  final bool dayReached;
  final int dayValue;

  @override
  Widget build(BuildContext context) {
    // if isToday is true need to highlight this day in green

    bool isToday = false;
    //getting the datatime now
    var d = DateTime.now();
    //getting the weekday value for today
    var weekDay = d.weekday;
    // if today's day value is the same as the day value we are representing then
    // this is representing today so isToday is true
    if (weekDay == dayValue) {
      isToday = true;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(getDayShort()),
            isToday
                //If is today is true show this
                ? Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      //Green highlight to show that this is today
                      color: Colors.green.withOpacity(0.25), // border color
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      // if we have reached this day in the week we need to show
                      // either a done icon or a clear icon as the user has
                      // either logged or not logged a workout on this day

                      // if we have not reached this day show the more time icon

                      // more time icon is blueGrey, done icon is green,
                      // clear icon is red
                      dayReached
                          ? (workoutPresent ? Icons.done : Icons.clear)
                          : Icons.more_time,
                      color: dayReached
                          ? (workoutPresent ? Colors.green : Colors.red)
                          : Colors.blueGrey,
                    ),
                  )
                //If is today is false show this
                : Icon(
                    //Same logic as above
                    dayReached
                        ? (workoutPresent ? Icons.done : Icons.clear)
                        : Icons.more_time,
                    color: dayReached
                        ? (workoutPresent ? Colors.green : Colors.red)
                        : Colors.blueGrey,
                  ),
          ],
        ),
      ),
    );
  }

  String getDayShort() {
    // get the day short string to say what day it is
    // 1 - MON
    // 2 - TUE
    // 3 - WED
    // 4 - THU
    // 5 - FRI
    // 6 - SAT
    // 7 - SUN
    String dayShort = "MON";
    switch (dayValue) {
      case 2:
        dayShort = "TUE";
        break;
      case 3:
        dayShort = "WED";
        break;
      case 4:
        dayShort = "THU";
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
