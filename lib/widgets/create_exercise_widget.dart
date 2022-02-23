import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_int_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/custom_text_form_field.dart';
import 'package:corefit_academy/utilities/validators/validate_int.dart';

class CreateExercisePage extends StatefulWidget {
  CreateExercisePage({Key? key, required this.workoutObject}) : super(key: key);
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final Workout workoutObject;
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameFieldTextEditingController =
      TextEditingController();
  TextEditingController repsFieldTextEditingController =
      TextEditingController();

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
              ),
            ),
            CustomTextFormField(
              controller: nameFieldTextEditingController,
              autoFocus: true,
              inputLabel: kExerciseNameFieldLabel,
              obscureText: false,
              textInputType: TextInputType.text,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            CustomIntFormField(
              controller: repsFieldTextEditingController,
              inputLabel: kRepsNameFieldLabel,
              activeColor: Theme.of(context).colorScheme.primary,
              validator: validateInt,
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
                    kNameField: nameFieldTextEditingController.text,
                    kViewersField: [],
                    kTargetedMusclesField: [],
                    kParentWorkoutField: widget.workoutObject.workoutReference,
                    kRpeField: 0,
                    kDistanceKmField: 0,
                    kPercentageOfExertionField: 0,
                    kRepsField: int.parse(repsFieldTextEditingController.text),
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
                  nameFieldTextEditingController.clear();
                  repsFieldTextEditingController.clear();

                  nameFieldTextEditingController.dispose();
                  repsFieldTextEditingController.dispose();
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
