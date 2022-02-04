import 'package:flutter/material.dart';

import 'package:corefit_academy/models/exercise.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExerciseDisplay extends StatelessWidget {
  ExerciseDisplay({Key? key, this.viewer = false, required this.exerciseObject})
      : super(key: key);
  bool viewer;
  final Exercise exerciseObject;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                      exerciseObject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
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
