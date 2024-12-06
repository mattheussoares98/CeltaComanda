import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteCheckPasswordByCustomerCode implements CheckPasswordByCustomerCode {
  final SoapRequest soapAdapter;
  RemoteCheckPasswordByCustomerCode({required this.soapAdapter});

  @override
  Future<SoapResponse> validate({
    required int customerCode,
    required String password,
  }) async {
    try {
      if (EnterpriseBuilder
              .entity!
              .enterpriseConcentradorParametersEntity!
              .celtaBSCrossIdentity!
              .isEmpty ==
          true) {
        throw DomainError.unexpected;
      }

      final soapResponse = await soapAdapter.post(
        parameters: {
          "crossIdentity": EnterpriseBuilder.entity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity,
          "customerCode": customerCode,
          "password": password,
        },
        typeOfResponse: "CheckPasswordByCustomerCodeResponse",
        soapAction: "CheckPasswordByCustomerCode",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "CheckPasswordByCustomerCodeResult",
      );

      return soapResponse;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
