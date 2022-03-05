import 'package:flutter/material.dart';

class DurationSelectedProvider with ChangeNotifier {
  Duration _value = const Duration(hours: 0, minutes: 0, seconds: 0);
  Duration get value => _value;

  void setValue(Duration value) {
    _value = value;
    notifyListeners();
  }
}
