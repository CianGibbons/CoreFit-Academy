import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  const CustomInputTextField(
      {Key? key,
      required this.iconData,
      required this.inputLabel,
      required this.obscureText})
      : super(key: key);

  final IconData iconData;
  final String inputLabel;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: TextField(
        obscureText: obscureText,
        onChanged: (value) {},
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          icon: Icon(
            iconData,
            color: Theme.of(context).colorScheme.secondary,
          ),
          labelText: inputLabel,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade600,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
