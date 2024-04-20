import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeEnterpriseValidation() => ValidationComposite(makeEnterpriseValidations());

List<FieldValidation> makeEnterpriseValidations() => [
      ...ValidationBuilder.field("enterpriseName").required().min(2).build(),
    ];
