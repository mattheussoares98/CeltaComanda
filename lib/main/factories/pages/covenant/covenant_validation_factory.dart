import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeCovenantValidation() =>
    ValidationComposite(_makeCovenantValidations());

List<FieldValidation> _makeCovenantValidations() => [
      ...ValidationBuilder.field("covenant").required().build(),
    ];
