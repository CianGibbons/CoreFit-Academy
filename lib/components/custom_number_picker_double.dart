import 'package:flutter/material.dart';
import 'package:corefit_academy/components/custom_number_picker_double_helper.dart';

class CustomNumberPickerDoubleHorizontal extends StatefulWidget {
  const CustomNumberPickerDoubleHorizontal({
    Key? key,
    required this.fieldName,
    required this.sendCurrentValue,
    required this.initialValue,
    this.maxValue = 100,
    this.minValue = 0,
    this.step = 1,
    this.itemHeight = 40,
    this.itemWidth = 40,
  }) : super(key: key);

  final String fieldName;
  final Function(double) sendCurrentValue;
  final double initialValue;
  final double maxValue;
  final double minValue;
  final double itemHeight;
  final double itemWidth;
  final double step;

  @override
  _CustomNumberPickerDoubleHorizontalState createState() =>
      _CustomNumberPickerDoubleHorizontalState();
}

class _CustomNumberPickerDoubleHorizontalState
    extends State<CustomNumberPickerDoubleHorizontal> {
  late double value;

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
                  double newValue = value - widget.step;
                  value = newValue.clamp(widget.minValue, widget.maxValue);
                  widget.sendCurrentValue(value);
                }),
              ),
              CustomNumberPickerDouble(
                minValue: widget.minValue,
                maxValue: widget.maxValue,
                value: value,
                step: widget.step,
                itemHeight: widget.itemHeight,
                itemWidth: widget.itemWidth,
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
                  double newValue = value + widget.step;
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
