import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  const CustomInputTextField({
    Key? key,
    this.iconData,
    required this.inputLabel,
    required this.obscureText,
    required this.onChanged,
    required this.textInputType,
    required this.activeColor,
    this.autoFocus = false,
  }) : super(key: key);

  final IconData? iconData;
  final String inputLabel;
  final bool obscureText;
  final Function(String) onChanged;
  final TextInputType textInputType;
  final Color activeColor;

  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: TextField(
        autofocus: autoFocus,
        keyboardType: textInputType,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          icon: Icon(
            iconData,
            color: activeColor,
          ),
          labelText: inputLabel,
          labelStyle: TextStyle(
            color: activeColor,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: activeColor,
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
