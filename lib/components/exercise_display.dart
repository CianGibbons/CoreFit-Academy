import 'package:flutter/material.dart';

import 'package:corefit_academy/models/exercise.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExerciseDisplay extends StatefulWidget {
  const ExerciseDisplay(
      {Key? key, this.viewer = false, required this.exerciseObject})
      : super(key: key);
  final bool viewer;
  final Exercise exerciseObject;

  @override
  State<ExerciseDisplay> createState() => _ExerciseDisplayState();
}

class _ExerciseDisplayState extends State<ExerciseDisplay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: Expand on Exercise Display
        print("Exercise: " + widget.exerciseObject.toString());
      },
      child: Padding(
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
              Container(
                child: widget.viewer
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
