import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() => [
      ...ValidationBuilder.field(R.string.user).required().build(),
      ...ValidationBuilder.field(R.string.password).required().build(),
      ...ValidationBuilder.field(R.string.urlCcs).required().build(),
    ];
