import 'package:flutter/material.dart';

class ValidWorkoutSelectedBoolProvider with ChangeNotifier {
  bool _value = false;
  bool? get value => _value;

  void setValue(bool value) {
    _value = value;
    notifyListeners();
  }
}
