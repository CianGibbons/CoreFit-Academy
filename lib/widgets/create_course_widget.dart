import 'package:corefit_academy/utilities/validators/validate_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import 'package:corefit_academy/utilities/providers/error_message_string_provider.dart';

class CreateCoursePage extends StatefulWidget {
  CreateCoursePage({Key? key}) : super(key: key);

  final FirebaseAuth _firebase = FirebaseAuth.instance;
  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _createCourseFormKey = GlobalKey<FormState>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Form(
        key: _createCourseFormKey,
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                kCreateCourseAction,
                style: kTitleStyle.copyWith(
                    color: Theme.of(context).colorScheme.primary),
              ),
            )),
            CustomTextFormField(
              validator: validateString,
              controller: textEditingController,
              autoFocus: true,
              inputLabel: kCourseNameFieldLabel,
              obscureText: false,
              textInputType: TextInputType.text,
              activeColor: Theme.of(context).colorScheme.primary,
              errorText: context.watch<ErrorMessageStringProvider>().value,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CustomElevatedButton(
                onPressed: () {
                  if (_createCourseFormKey.currentState!.validate() &&
                      textEditingController.text.isNotEmpty) {
                    // widget.user.uid
                    // courseName
                    _firestore.collection(kCoursesCollection).add({
                      kCreatedAtField: DateTime.now(),
                      kUserIdField: widget._firebase.currentUser!.uid,
                      kNameField: textEditingController.text,
                      kWorkoutsField: [],
                      kViewersField: [],
                    });
                    textEditingController.clear();
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
                child: const Text(kCreateCourseActionButton),
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
