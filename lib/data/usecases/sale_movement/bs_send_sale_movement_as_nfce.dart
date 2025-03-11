import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../infra/http/http.dart';
import '../../../main/builders/builders.dart';

class BsSendSaleMovementAsNfce implements SendSaleMovementAsNfce {
  final SoapAdapter soapAdapter;

  BsSendSaleMovementAsNfce({required this.soapAdapter});

  @override
  Future<SoapResponse> send(String xml) async {
    try {
      final enterprise =
          EnterpriseBuilder.entity?.enterpriseConcentradorParametersEntity;
      final result = await soapAdapter.post(
        parameters: {
          "crossIdentity": enterprise?.celtaBSCrossIdentity,
          "enterpriseCode": enterprise?.enterprise?.enterpriseCode,
          "xmlSaleMovement": xml,
        },
        typeOfResponse: "SendSaleMovementAsNFCeResponse",
        typeOfResult: "SendSaleMovementAsNFCeResult",
        soapAction: "SendSaleMovementAsNFCe",
        serviceASMX: "CeltaSaleMovementService.asmx",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
