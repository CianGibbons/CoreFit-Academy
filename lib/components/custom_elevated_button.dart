import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      required this.backgroundColor})
      : super(key: key);

  // pass in the method to be called on the press of the button
  final VoidCallback onPressed;
  //The child will likely be the Text Widget to have inside the button
  final Widget child;
  // The background color of the button
  final Color backgroundColor;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: widget.child,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
      ),
    );
  }
}
