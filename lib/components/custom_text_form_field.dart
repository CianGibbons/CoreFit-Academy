import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    Key? key,
    this.iconData,
    required this.controller,
    required this.inputLabel,
    required this.obscureText,
    required this.textInputType,
    required this.activeColor,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.errorText,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.paddingAll = 20.0,
    this.autoFocus = false,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData? iconData;
  final String inputLabel;
  final bool obscureText;
  final TextInputType textInputType;
  final Color activeColor;
  final double paddingAll;
  final bool autoFocus;
  final String? Function(String?)? validator;
  final Future<void> Function(String?)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? errorText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    //Widget with the options all passed in as needed
    return Container(
      margin: EdgeInsets.all(widget.paddingAll),
      child: TextFormField(
        onEditingComplete: widget.onEditingComplete,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        controller: widget.controller,
        autofocus: widget.autoFocus,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        decoration: InputDecoration(
          errorText: widget.errorText,
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
