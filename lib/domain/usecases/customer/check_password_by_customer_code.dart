import '../../../infra/helpers/helperts.dart';

abstract class CheckPasswordByCustomerCode {
  Future<SoapResponse> validate({
    required int customerCode,
    required String password,
  });
}
