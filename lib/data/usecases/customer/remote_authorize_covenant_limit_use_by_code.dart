import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteAuthorizeCovenantLimitUseByCode
    implements AuthorizeCovenantLimitUseByCode {
  final SoapRequest soapAdapter;
  RemoteAuthorizeCovenantLimitUseByCode({required this.soapAdapter});

  @override
  Future<void> authorize({
    required String crossIdentity,
    required int covenantCode,
    required int customerCode,
    required double value,
  }) async {
    try {
      if (EnterpriseDataBuilder
              .enterpriseDataEntity!
              .enterpriseConcentradorParametersEntity!
              .celtaBSCrossIdentity!
              .isEmpty ==
          true) {
        throw DomainError.unexpected;
      }
      final jsonData = await soapAdapter.post(
        parameters: {
          "crossIdentity": EnterpriseDataBuilder.enterpriseDataEntity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity,
          "covenantCode": covenantCode,
          "customerCode": customerCode,
          "value": value,
        },
        typeOfResponse: "AuthorizeConveneLimitUseByCodeResponse",
        soapAction: "AuthorizeConveneLimitUseByCode",
        serviceASMX: "CeltaLimitService.asmx",
        typeOfResult: null,
      );

      print(jsonData);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
