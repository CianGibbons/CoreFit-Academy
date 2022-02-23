import 'package:corefit_academy/utilities/constants.dart';

String? validateInt(String? value) {
  String pattern = r'[0-9]';
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return kErrorEnterValidIntString;
  } else {
    // Email Syntax Valid
    return null;
  }
}
