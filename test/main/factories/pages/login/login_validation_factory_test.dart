import 'package:clean_celta_mobile/validation/validators/validators.dart';
import 'package:clean_celta_mobile/main/factories/factories.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      const RequiredFieldValidation("user"),
      const RequiredFieldValidation("password"),
      const RequiredFieldValidation("urlCcs"),
    ]);
  });
}
