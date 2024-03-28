import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/validation/validators/validators.dart';
import 'package:clean_celta_mobile/main/factories/factories.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation(R.string.user),
      RequiredFieldValidation(R.string.password),
      RequiredFieldValidation(R.string.urlCcs),
    ]);
  });
}
