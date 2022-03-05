import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomIntFormField extends StatefulWidget {
  const CustomIntFormField({
    Key? key,
    this.iconData,
    required this.controller,
    required this.inputLabel,
    required this.activeColor,
    this.validator,
    this.obscureText = false,
    this.onSaved,
    this.onFieldSubmitted,
    this.errorText,
    this.paddingAll = 20.0,
    this.autoFocus = false,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData? iconData;
  final String inputLabel;
  final bool obscureText;
  final Color activeColor;
  final double paddingAll;
  final bool autoFocus;
  final String? Function(String?)? validator;
  final Future<void> Function(String?)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? errorText;
  @override
  _CustomIntFormFieldState createState() => _CustomIntFormFieldState();
}

class _CustomIntFormFieldState extends State<CustomIntFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(widget.paddingAll),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: widget.validator,
        controller: widget.controller,
        autofocus: widget.autoFocus,
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
