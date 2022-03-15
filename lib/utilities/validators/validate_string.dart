import 'package:corefit_academy/utilities/constants.dart';

String? validateString(String? value) {
  if (value == null || value.isEmpty) {
    return kErrorEnterValidNameString;
  } else {
    // Email Syntax Valid
    return null;
  }
}
