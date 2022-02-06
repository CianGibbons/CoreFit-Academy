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
  TextEditingController textEditingController = TextEditingController();
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
      child: Form(
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                kCreateExerciseAction,
                style: kTitleStyle.copyWith(
                    color: Theme.of(context).colorScheme.primary),
              ),
            )),
            CustomInputTextField(
              controller: textEditingController,
              autoFocus: true,
              inputLabel: kExerciseNameFieldLabel,
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
                  _firestore.collection(kExercisesCollection).add({
                    kCreatedAtField: DateTime.now(),
                    kUserIdField: widget._firebase.currentUser!.uid,
                    kNameField: exerciseName,
                    kViewersField: [],
                    kTargetedMusclesField: [],
                    kParentWorkoutField: widget.workoutObject.workoutReference,
                    kRpeField: 0,
                    kDistanceKmField: 0,
                    kPercentageOfExertionField: 0,
                    kRepsField: 0,
                    kSetsField: 0,
                    kTimeHoursField: 0,
                    kTimeMinutesField: 0,
                    kTimeSecondsField: 0,
                    kWeightKgField: 0
                  }).then((value) {
                    List idList = [];
                    idList.add(kExercisesCollection + '/' + value.id);
                    _firestore
                        .collection(kWorkoutsCollection)
                        .doc(widget.workoutObject.workoutReference.id)
                        .update(
                            {kExercisesField: FieldValue.arrayUnion(idList)});
                  });
                  textEditingController.clear();
                },
                child: const Text(kCreateExerciseActionButton),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}
