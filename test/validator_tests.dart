import 'package:corefit_academy/utilities/constants.dart';
import 'package:corefit_academy/utilities/validators/validate_email.dart';
import 'package:corefit_academy/utilities/validators/validate_int.dart';
import 'package:corefit_academy/utilities/validators/validate_string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Validators", () {
    test("Testing Validate Email", () {
      //ensuring that valid emails don't return error message and invalid ones do
      expect(validateEmail("email@corefitacademy.ie"), equals(null));
      expect(validateEmail("NOTANEMAIL"), equals(kErrorEnterValidEmailString));
    });

    test("Testing Validate Int", () {
      //ensuring that valid ints don't return error message and invalid ones do
      expect(validateInt("1"), equals(null));
      expect(validateInt("NOT AN INT"), equals(kErrorEnterValidIntString));
    });

    test("Testing Validate String", () {
      //ensuring that valid strings don't return error message and invalid ones do
      expect(validateString("Valid String"), equals(null));
      expect(validateString(""), equals(kErrorEnterValidNameString));
    });
  });
}
