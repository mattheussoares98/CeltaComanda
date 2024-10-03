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
    required String? crossIdentity,
    required int covenantCode,
    required int customerCode,
    required double value,
  }) async {
    try {
      if (EnterpriseDataBuilder.enterpriseDataEntity!
                  .enterpriseConcentradorParametersEntity ==
              null ||
          EnterpriseDataBuilder
                  .enterpriseDataEntity!
                  .enterpriseConcentradorParametersEntity!
                  .celtaBSCrossIdentity ==
              null) {
        throw DomainError.unexpected;
      }

      final result = await soapAdapter.post(
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
        typeOfResult: "authorizedCode",
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
