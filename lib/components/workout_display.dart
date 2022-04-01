import 'package:corefit_academy/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:corefit_academy/screens/workout_page.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/models/course.dart';

class WorkoutDisplay extends StatefulWidget {
  const WorkoutDisplay(
      {Key? key,
      required this.parentCourseObject,
      required this.workoutObject,
      this.viewer = false})
      : super(key: key);
  final bool viewer;
  final Workout workoutObject;
  final Course parentCourseObject;

  @override
  State<WorkoutDisplay> createState() => _WorkoutDisplayState();
}

class _WorkoutDisplayState extends State<WorkoutDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("Workout: " + widget.workoutObject.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutPage(
              workoutObject: widget.workoutObject,
              parentCourseObject: widget.parentCourseObject,
              viewer: widget.viewer,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
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
                      widget.workoutObject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    Text(kShowNumberExercisesForWorkout +
                        widget.workoutObject.numExercises.toString()),
                  ],
                ),
              ),
              Container(
                child: widget.viewer
                    ? const Icon(Icons.remove_red_eye_outlined)
                    : const Icon(FontAwesomeIcons.pencil),
              )
            ],
          ),
        ),
      ),
    );
  }
}
