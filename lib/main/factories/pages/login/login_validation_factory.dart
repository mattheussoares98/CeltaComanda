import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeLoginValidation() => ValidationComposite(makeLoginValidations());

List<FieldValidation> makeLoginValidations() => [
      ...ValidationBuilder.field("user").required().build(),
      ...ValidationBuilder.field("password").required().build(),
      ...ValidationBuilder.field("urlCcs").required().build(),
    ];
