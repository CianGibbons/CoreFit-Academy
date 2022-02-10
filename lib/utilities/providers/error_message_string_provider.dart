import 'package:flutter/material.dart';

class ErrorMessageStringProvider with ChangeNotifier {
  String? _value;
  String? get value => _value;

  void setValue(String? value) {
    _value = value;
    notifyListeners();
  }
}
