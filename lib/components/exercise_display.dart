import 'package:corefit_academy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/exercise.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';

import 'package:corefit_academy/controllers/exercise_request_controller.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/models/workout.dart';

class ExerciseDisplay extends StatefulWidget {
  const ExerciseDisplay(
      {Key? key,
      this.viewer = false,
      required this.exerciseObject,
      required this.parentWorkoutObject,
      required this.grandparentCourseObject})
      : super(key: key);
  final bool viewer;
  final Exercise exerciseObject;
  final Workout parentWorkoutObject;
  final Course grandparentCourseObject;

  @override
  State<ExerciseDisplay> createState() => _ExerciseDisplayState();
}

class _ExerciseDisplayState extends State<ExerciseDisplay> {
  @override
  Widget build(BuildContext context) {
    if (!widget.viewer) {
      // If user owns the exercise
      return Slidable(
        // Specify a key if the Slidable is dismissible. 1 - NOT DISMISSIBLE
        key: const ValueKey(1),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            //Slideable Action with delete icon in white on a red background
            SlidableAction(
              onPressed: showDeleteOwnedExerciseDialog,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // circular corners on the container with a padding all around
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                //Take up as much space as is available
                Expanded(
                  child: Column(
                    // items in the column stretched among the column
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //display all of the info about the exercise
                      Text(
                        widget.exerciseObject.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Text(
                        "Sets: " + widget.exerciseObject.sets.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Reps: " + widget.exerciseObject.reps.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Distance (KM): " +
                            widget.exerciseObject.distanceKM.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Weight (KG): " +
                            widget.exerciseObject.weightKG.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "RPE: " + widget.exerciseObject.rpe.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Percentage of Exertion: " +
                            widget.exerciseObject.percentageOfExertion
                                .toString() +
                            "%",
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Time: " +
                            widget.exerciseObject.getTotalTime().toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Targeted Muscle Group: " +
                            widget.exerciseObject.targetedMuscleGroup,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        "Targeted Muscles:\n\t\t\t\t\t\t" +
                            widget.exerciseObject.targetedMuscles!
                                .join('\n\t\t\t\t\t\t'),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(FontAwesomeIcons.pencil)
              ],
            ),
          ),
        ),
      );
    }
    // if user doesn't own the exercise
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        // height: 100,
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
                    widget.exerciseObject.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  Text(
                    "Sets: " + widget.exerciseObject.sets.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Reps: " + widget.exerciseObject.reps.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Distance (KM): " +
                        widget.exerciseObject.distanceKM.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Weight (KG): " + widget.exerciseObject.weightKG.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "RPE: " + widget.exerciseObject.rpe.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Percentage of Exertion: " +
                        widget.exerciseObject.percentageOfExertion.toString() +
                        "%",
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Time: " + widget.exerciseObject.getTotalTime().toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Targeted Muscle Group: " +
                        widget.exerciseObject.targetedMuscleGroup,
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Targeted Muscles:\n\t\t\t\t\t\t" +
                        widget.exerciseObject.targetedMuscles!
                            .join('\n\t\t\t\t\t\t'),
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.remove_red_eye_outlined)
          ],
        ),
      ),
    );
  }

  void showDeleteOwnedExerciseDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
              child: AlertDialog(
            title: const Text(kDeleteExerciseAction),
            actions: <Widget>[
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    deleteOwnedExercise(
                      context,
                      widget.exerciseObject.exerciseReference.id,
                      widget.exerciseObject.parentWorkoutReference.id,
                      widget.parentWorkoutObject,
                      widget.grandparentCourseObject,
                    );
                  });
                },
                child: const Text(kDelete),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              CustomElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text(kCancel),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ));
        });
  }
}
