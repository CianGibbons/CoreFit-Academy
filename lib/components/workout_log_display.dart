import 'package:corefit_academy/models/workout_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:corefit_academy/screens/logged_exercises_page.dart';
import 'package:corefit_academy/utilities/constants.dart';

class WorkoutLogDisplay extends StatelessWidget {
  const WorkoutLogDisplay({Key? key, required this.workoutLog})
      : super(key: key);
  final WorkoutLog workoutLog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseLogPage(
              workoutLog: workoutLog,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      workoutLog.courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      workoutLog.workoutName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(DateFormat('yyyy-MM-dd – HH:mm')
                        .format(workoutLog.createdAt)),
                    Text(kShowNumberExercisesLoggedForWorkout +
                        workoutLog.exercises!.length.toString()),
                  ],
                ),
              ),
              const Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
