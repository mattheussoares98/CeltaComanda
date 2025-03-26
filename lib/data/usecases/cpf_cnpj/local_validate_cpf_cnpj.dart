import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../../domain/usecases/usecases.dart';

class LocalValidateCpfCnpj implements ValidateCpfCnpj {
  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    } else if (value.length != 11 && value.length != 14) {
      return false;
    } else if (value.length == 11 && CPFValidator.isValid(value)) {
      return true;
    } else if (value.length == 14 && CNPJValidator.isValid(value)) {
      return true;
    } else {
      return false;
    }
  }
}
