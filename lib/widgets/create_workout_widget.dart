import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:corefit_academy/models/course.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateWorkoutPage extends StatefulWidget {
  CreateWorkoutPage({
    Key? key,
    required this.courseObject,
  }) : super(key: key);
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  final Course courseObject;
  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String workoutName = "";
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
              'Create New Workout',
              style: kTitleStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary),
            ),
          )),
          CustomInputTextField(
            autoFocus: true,
            inputLabel: "Workout Name",
            obscureText: false,
            onChanged: (value) {
              setState(() {
                workoutName = value;
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
                // widget.user.uid
                // courseName
                _firestore.collection('workouts').add({
                  'createdAt': DateTime.now(),
                  'userId': widget._firebase.currentUser!.uid,
                  'name': workoutName,
                  'exercises': [],
                  'viewers': [],
                  'targetedMuscles': [],
                  'parentCourse': widget.courseObject.courseReference,
                }).then((value) {
                  List idList = [];
                  idList.add('workouts/' + value.id);
                  _firestore
                      .collection('courses')
                      .doc(widget.courseObject.courseReference.id)
                      .update({'workouts': FieldValue.arrayUnion(idList)});
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
