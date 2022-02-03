import 'package:corefit_academy/components/custom_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/components/custom_elevated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateCoursePage extends StatefulWidget {
  CreateCoursePage({Key? key, required this.user}) : super(key: key);

  final User user;
  @override
  _CreateCoursePageState createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String courseName = "";

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
              'Create New Course',
              style: kTitleStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary),
            ),
          )),
          CustomInputTextField(
            autoFocus: true,
            inputLabel: "Course Name",
            obscureText: false,
            onChanged: (value) {
              setState(() {
                courseName = value;
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
                _firestore
                    .collection('courses')
                    .add({'userId': widget.user.uid, 'name': courseName});
              },
              child: const Text('Create Course'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
