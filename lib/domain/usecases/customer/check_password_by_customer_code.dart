import '../../../infra/helpers/helpers.dart';

abstract class CheckPasswordByCustomerCode {
  Future<SoapResponse> validate({
    required int customerCode,
    required String password,
  });
}
