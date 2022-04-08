import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomNumberPickerHorizontal extends StatefulWidget {
  const CustomNumberPickerHorizontal({
    Key? key,
    required this.fieldName,
    required this.sendCurrentValue,
    required this.initialValue,
    this.maxValue = 100,
    this.minValue = 0,
    this.step = 1,
    this.itemHeight = 40,
    this.itemWidth = 40,
    this.fontSize = 20,
  }) : super(key: key);

  final String fieldName;
  final Function(int) sendCurrentValue;
  final int initialValue;
  final int maxValue;
  final int minValue;
  final double itemHeight;
  final double itemWidth;
  final int step;
  final double fontSize;

  @override
  _CustomNumberPickerHorizontalState createState() =>
      _CustomNumberPickerHorizontalState();
}

class _CustomNumberPickerHorizontalState
    extends State<CustomNumberPickerHorizontal> {
  late int value;

  @override
  void initState() {
    //set the initial value of the number picker
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          //Show the field name
          Text(
            widget.fieldName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              // fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show the subtract button
              // decrement by the value of step on press,
              // clamp the value to the minimum and maximum value to
              // ensure it stays within the range
              // use the send current value to send the value back to the screen
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => setState(() {
                  int newValue = value - widget.step;
                  value = newValue.clamp(widget.minValue, widget.maxValue);
                  widget.sendCurrentValue(value);
                }),
              ),
              NumberPicker(
                // Show the number picker with the current value
                // on change update the value and setState to show it
                minValue: widget.minValue,
                maxValue: widget.maxValue,
                value: value,
                step: widget.step,
                itemHeight: widget.itemHeight,
                itemWidth: widget.itemWidth,
                selectedTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                ),
                axis: Axis.horizontal,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black26),
                ),
                haptics: true,
                onChanged: (val) {
                  setState(() {
                    value = val;
                    widget.sendCurrentValue(value);
                  });
                },
              ),
              IconButton(
                // Show the add button
                // increment by the value of step on press,
                // clamp the value to the minimum and maximum value to
                // ensure it stays within the range
                // use the send current value to send the value back to the screen
                icon: const Icon(Icons.add_circle_outline),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => setState(() {
                  int newValue = value + widget.step;
                  value = newValue.clamp(widget.minValue, widget.maxValue);
                  widget.sendCurrentValue(value);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
