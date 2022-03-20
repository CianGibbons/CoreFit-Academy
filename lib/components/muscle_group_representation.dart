import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class MuscleGroupRepresentation extends StatelessWidget {
  const MuscleGroupRepresentation(
      {Key? key, required this.muscleGroupName, required this.value})
      : super(key: key);

  //The Muscle Group Name
  final String muscleGroupName;
  //The Number of Entries with this Group
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              muscleGroupName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            Text(kShowNumberExercisesForMuscleGroup + value.toString()),
          ],
        ),
      ),
    );
  }
}
