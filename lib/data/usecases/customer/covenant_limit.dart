import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteCovenantLimit implements CovenantLimit {
  final SoapRequest soapAdapter;
  RemoteCovenantLimit({required this.soapAdapter});

  @override
  Future<SoapResponse> authorizeCovenantLimitUseByCodeAndGetAuthorizeCode({
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

      final soapResponse = await soapAdapter.post(
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

      return soapResponse;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
