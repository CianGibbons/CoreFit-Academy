import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';

class CreateExercisePage extends StatefulWidget {
  CreateExercisePage({Key? key, required this.workoutObject}) : super(key: key);
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final Workout workoutObject;
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String exerciseName = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Create New Exercise',
              style: kTitleStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary),
            ),
          )),
          CustomInputTextField(
            autoFocus: true,
            inputLabel: "Exercise Name",
            obscureText: false,
            onChanged: (value) {
              setState(() {
                exerciseName = value;
              });
            },
            textInputType: TextInputType.text,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: CustomElevatedButton(
              onPressed: () {
                _firestore.collection('exercises').add({
                  'createdAt': DateTime.now(),
                  'userId': widget._firebase.currentUser!.uid,
                  'name': exerciseName,
                  'viewers': [],
                  'targetedMuscles': [],
                  'parentWorkout': widget.workoutObject.workoutReference,
                  'RPE': 0,
                  'distanceKm': 0,
                  'percentageOfExertion': 0,
                  'reps': 0,
                  'sets': 0,
                  'timeHours': 0,
                  'timeMinutes': 0,
                  'timeSeconds': 0,
                  'weightKg': 0
                }).then((value) {
                  List idList = [];
                  idList.add('exercises/' + value.id);
                  _firestore
                      .collection('workouts')
                      .doc(widget.workoutObject.workoutReference.id)
                      .update({'exercises': FieldValue.arrayUnion(idList)});
                });
              },
              child: const Text('Create Workout'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
