import 'package:flutter/material.dart';

class CustomInputTextField extends StatefulWidget {
  const CustomInputTextField({
    Key? key,
    this.iconData,
    required this.controller,
    required this.inputLabel,
    required this.obscureText,
    required this.onChanged,
    required this.textInputType,
    required this.activeColor,
    this.paddingAll = 20.0,
    this.autoFocus = false,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData? iconData;
  final String inputLabel;
  final bool obscureText;
  final Function(String) onChanged;
  final TextInputType textInputType;
  final Color activeColor;
  final double paddingAll;
  final bool autoFocus;

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}

class _CustomInputTextFieldState extends State<CustomInputTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // set the margin for the container widget surrounding the text field
      margin: EdgeInsets.all(widget.paddingAll),
      // Add in the controller, the auto focus option, the text input type,
      // the obscure text option, the on Changed function, the active color,
      // the icon data and the input label into the Text Field.
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autoFocus,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          icon: Icon(
            widget.iconData,
            color: widget.activeColor,
          ),
          labelText: widget.inputLabel,
          labelStyle: TextStyle(
            color: widget.activeColor,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.activeColor,
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
