import 'package:corefit_academy/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/screens/workout_page.dart';

class WorkoutDisplay extends StatelessWidget {
  WorkoutDisplay({Key? key, required this.workoutObject, this.viewer = false})
      : super(key: key);
  bool viewer;
  final Workout workoutObject;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutPage(
              workoutObject: workoutObject,
              viewer: viewer,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      workoutObject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    Text("Number of Exercises in Workout: " +
                        workoutObject.numExercises.toString()),
                  ],
                ),
              ),
              Container(
                child: viewer
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(FontAwesomeIcons.pencilAlt),
              )
            ],
          ),
        ),
      ),
    );
  }
}