import 'package:corefit_academy/controllers/exercise_request_controller.dart';
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
import 'package:corefit_academy/components/custom_number_picker_double.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:corefit_academy/models/muscle.dart';

class CreateExercisePage extends StatefulWidget {
  const CreateExercisePage({Key? key, required this.workoutObject})
      : super(key: key);
  final Workout workoutObject;
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final TextEditingController nameFieldTextEditingController =
      TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  int currentSetsValue = 0;
  int currentRepsValue = 0;
  int currentRPEValue = 1;
  double currentDistanceValue = 0.0;
  double currentWeightValue = 0.0;
  double currentPercentageOfExertionValue = 0;
  List<Muscle> selectedTargetedMusclesNames = [];
  String selectedTargetedMuscleGroup =
      kTargetMuscleGroupsNames[MuscleGroup.chest.index];
  List<Muscle> targetMusclesItemsList = kMusclesList[0];

  @override
  Widget build(BuildContext context) {
    final _createExerciseFormKey = GlobalKey<FormState>();
    var viewers = widget.workoutObject.viewers;

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
                  CustomNumberPickerDoubleHorizontal(
                    fieldName: kDistanceKMNameFieldLabel,
                    initialValue: currentDistanceValue,
                    maxValue: 200000,
                    step: 200,
                    itemWidth: 80,
                    sendCurrentValue: (double value) {
                      currentDistanceValue = value;
                    },
                  ),
                  CustomNumberPickerDoubleHorizontal(
                    fieldName: kWeightKGNameFieldLabel,
                    initialValue: currentWeightValue,
                    maxValue: 200.0,
                    step: 0.5,
                    itemWidth: 80,
                    sendCurrentValue: (double value) {
                      currentWeightValue = value;
                    },
                  ),
                  CustomNumberPickerDoubleHorizontal(
                    fieldName: kPercentageOfExertionNameFieldLabel,
                    initialValue: currentPercentageOfExertionValue,
                    maxValue: 100,
                    step: 1,
                    itemWidth: 80,
                    sendCurrentValue: (double value) {
                      currentPercentageOfExertionValue = value;
                    },
                  ),
                  Text(
                    selectedTargetedMuscleGroup,
                  ),
                  CustomElevatedButton(
                    onPressed: handleSetTargetedMuscleGroup,
                    child: const Text(kSetMuscleGroupTitle),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    selectedTargetedMusclesNames.toString(),
                  ),
                  CustomElevatedButton(
                    onPressed: handleSetTargetedMuscles,
                    child: const Text(kSetTargetedMusclesTitle),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    context.read<DurationSelectedProvider>().value.toString(),
                  ),
                  CustomElevatedButton(
                    onPressed: handleSetTimeClick,
                    child: const Text(kSetTimeAction),
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
                          List<Map> listOfMuscles = [];
                          for (Muscle targetedMuscle
                              in selectedTargetedMusclesNames) {
                            listOfMuscles.add({
                              kMuscleNameField: targetedMuscle.muscleName,
                              kMuscleGroupIndexField:
                                  targetedMuscle.muscleGroup.index,
                            });
                          }

                          Duration timeForExercise =
                              context.read<DurationSelectedProvider>().value;
                          int hours = timeForExercise.inHours;
                          int minutes =
                              timeForExercise.inMinutes - (hours * 60);
                          int seconds = timeForExercise.inSeconds -
                              ((hours * 60 * 60) + (minutes * 60));

                          createExercise(
                              exerciseName: nameFieldTextEditingController.text,
                              viewers: viewers!,
                              selectedTargetedMuscleGroup:
                                  selectedTargetedMuscleGroup,
                              listOfMuscles: listOfMuscles,
                              workoutObject: widget.workoutObject,
                              currentDistanceValue: currentDistanceValue,
                              currentPercentageOfExertionValue:
                                  currentPercentageOfExertionValue,
                              currentWeightValue: currentWeightValue,
                              currentRPEValue: currentRPEValue,
                              currentRepsValue: currentRepsValue,
                              currentSetsValue: currentSetsValue,
                              hours: hours,
                              minutes: minutes,
                              seconds: seconds);

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

  void handleSetTargetedMuscleGroup() {
    showMaterialScrollPicker<String>(
      headerColor: Theme.of(context).colorScheme.primary,
      title: kSelectMuscleGroupTitle,
      context: context,
      items: kTargetMuscleGroupsNames,
      selectedItem: selectedTargetedMuscleGroup,
      onChanged: (value) => setState(() {
        selectedTargetedMuscleGroup = value;
        selectedTargetedMusclesNames = [];
        targetMusclesItemsList =
            kMusclesList[kTargetMuscleGroupsNames.indexOf(value)];
      }),
    );
  }

  void handleSetTargetedMuscles() {
    showMaterialCheckboxPicker<Muscle>(
      headerColor: Theme.of(context).colorScheme.primary,
      context: context,
      title: kSelectTargetedMusclesTitle,
      items: targetMusclesItemsList,
      selectedItems: selectedTargetedMusclesNames,
      onChanged: (value) =>
          setState(() => selectedTargetedMusclesNames = value),
    );
  }
}
