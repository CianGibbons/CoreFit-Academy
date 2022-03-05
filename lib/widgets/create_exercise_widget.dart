import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/models/workout.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/custom_text_form_field.dart';
import 'package:corefit_academy/components/custom_number_picker.dart';
import 'package:corefit_academy/utilities/validators/validate_string.dart';
import 'package:provider/provider.dart';
import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:corefit_academy/utilities/providers/duration_selected_provider.dart';

class CreateExercisePage extends StatefulWidget {
  CreateExercisePage({Key? key, required this.workoutObject}) : super(key: key);
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final Workout workoutObject;
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

int currentSetsValue = 0;
int currentRepsValue = 0;
int currentRPEValue = 1;
int currentDistanceValue = 0;

class _CreateExercisePageState extends State<CreateExercisePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameFieldTextEditingController =
      TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final _createExerciseFormKey = GlobalKey<FormState>();

    // Getting the height of the SafeArea
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double maxHeight = height - padding.top - padding.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight - (kToolbarHeight * 2)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: GestureDetector(
          child: ListView(
            children: [
              Form(
                key: _createExerciseFormKey,
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
                      autoFocus: true,
                      controller: nameFieldTextEditingController,
                      inputLabel: kExerciseNameFieldLabel,
                      obscureText: false,
                      textInputType: TextInputType.text,
                      activeColor: Theme.of(context).colorScheme.primary,
                      validator: validateString,
                      errorText:
                          context.watch<ErrorMessageStringProvider>().value,
                    ),
                    CustomNumberPickerHorizontal(
                      fieldName: kSetsNameFieldLabel,
                      initialValue: currentSetsValue,
                      itemWidth: 80,
                      sendCurrentValue: (int value) {
                        currentSetsValue = value;
                      },
                    ),
                    CustomNumberPickerHorizontal(
                      fieldName: kRepsNameFieldLabel,
                      initialValue: currentRepsValue,
                      itemWidth: 80,
                      sendCurrentValue: (int value) {
                        currentRepsValue = value;
                      },
                    ),
                    CustomNumberPickerHorizontal(
                      fieldName: kREPNameFieldLabel,
                      initialValue: currentRPEValue,
                      maxValue: 10,
                      minValue: 1,
                      itemWidth: 80,
                      sendCurrentValue: (int value) {
                        currentRPEValue = value;
                      },
                    ),
                    CustomNumberPickerHorizontal(
                      fieldName: kDistanceKMNameFieldLabel,
                      initialValue: currentDistanceValue,
                      maxValue: 42000,
                      step: 200,
                      itemWidth: 80,
                      sendCurrentValue: (int value) {
                        currentDistanceValue = value;
                      },
                    ),
                    Text(context
                        .read<DurationSelectedProvider>()
                        .value
                        .toString()),
                    CustomElevatedButton(
                      onPressed: handleSetTimeClick,
                      child: const Text("Set Time"),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: CustomElevatedButton(
                        onPressed: () {
                          if (_createExerciseFormKey.currentState!.validate() &&
                              nameFieldTextEditingController.text.isNotEmpty) {
                            Duration timeForExercise =
                                context.read<DurationSelectedProvider>().value;
                            int hours = timeForExercise.inHours;
                            int minutes =
                                timeForExercise.inMinutes - (hours * 60);
                            int seconds = timeForExercise.inSeconds -
                                ((hours * 60 * 60) + (minutes * 60));

                            _firestore.collection(kExercisesCollection).add({
                              kCreatedAtField: DateTime.now(),
                              kUserIdField: widget._firebase.currentUser!.uid,
                              kNameField: nameFieldTextEditingController.text,
                              kViewersField: [],
                              kTargetedMusclesField: [],
                              kParentWorkoutField:
                                  widget.workoutObject.workoutReference,
                              kRpeField: currentRPEValue,
                              kDistanceKmField: currentDistanceValue.round(),
                              kPercentageOfExertionField: 0,
                              kRepsField: currentRepsValue,
                              kSetsField: currentSetsValue,
                              kTimeHoursField: hours,
                              kTimeMinutesField: minutes,
                              kTimeSecondsField: seconds,
                              kWeightKgField: 0
                            }).then((value) {
                              List idList = [];
                              idList.add(kExercisesCollection + '/' + value.id);
                              _firestore
                                  .collection(kWorkoutsCollection)
                                  .doc(widget.workoutObject.workoutReference.id)
                                  .update({
                                kExercisesField: FieldValue.arrayUnion(idList)
                              });
                            });
                            nameFieldTextEditingController.clear();
                            context
                                .read<ErrorMessageStringProvider>()
                                .setValue(null);
                            Navigator.pop(context);
                          } else {
                            // Set the Error Message to Please Enter a Name for the Exercise
                            // This also notifies any widget that a change has been made
                            // these widgets will then rebuild due to the update in this value
                            // ie. the text field will show that the Name Field is empty in this case.
                            context
                                .read<ErrorMessageStringProvider>()
                                .setValue(kErrorEnterValidNameString);
                          }
                        },
                        child: const Text(kCreateExerciseActionButton),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20.0)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSetTimeClick() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Duration? resultingDuration = await showDurationPicker(
      context: context,
      initialTime: context.read<DurationSelectedProvider>().value,
      baseUnit: BaseUnit.second,
    );
    // Updating the Duration Value Provider so that it is set to the resulting Duration
    context.read<DurationSelectedProvider>().setValue(resultingDuration!);
    // Setting State to ensure that the duration value is updated on the Modal Sheet
    setState(() {});
  }
}
