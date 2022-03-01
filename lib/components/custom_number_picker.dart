import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomNumberPicker extends StatefulWidget {
  const CustomNumberPicker({
    Key? key,
    required this.fieldName,
    required this.sendCurrentValue,
    required this.initialValue,
  }) : super(key: key);

  final String fieldName;
  final Function(int) sendCurrentValue;
  final int initialValue;

  @override
  _CustomNumberPickerState createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  late int value;

  @override
  void initState() {
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
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => setState(() {
                  int newValue = value - 1;
                  value = newValue.clamp(0, 100);
                  widget.sendCurrentValue(value);
                }),
              ),
              NumberPicker(
                minValue: 0,
                maxValue: 100,
                value: value,
                step: 1,
                itemHeight: 40,
                itemWidth: 40,
                selectedTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
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
                icon: const Icon(Icons.add_circle_outline),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => setState(() {
                  int newValue = value + 1;
                  value = newValue.clamp(0, 100);
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
