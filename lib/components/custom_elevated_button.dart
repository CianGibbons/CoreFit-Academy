import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      required this.backgroundColor})
      : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
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
