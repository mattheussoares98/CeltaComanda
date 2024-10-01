import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeCustomerValidation() =>
    ValidationComposite(_makeCustomerValidations());

List<FieldValidation> _makeCustomerValidations() => [
      ...ValidationBuilder.field("customer").required().build(),
    ];
