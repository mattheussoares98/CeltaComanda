import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class BsSendSaleMovementAsNfce implements SendSaleMovementAsNfce {
  final SoapRequest soapAdapter;

  BsSendSaleMovementAsNfce({required this.soapAdapter});

  @override
  Future<SoapResponse> send(String xml) async {
    try {
      final enterprise =
          EnterpriseBuilder.entity?.enterpriseConcentradorParametersEntity;
      final result = await soapAdapter.post(
        addXmlnsInParameterTag: true,
        parameters: {
          "crossIdentity": enterprise?.celtaBSCrossIdentity,
          "enterpriseCode": enterprise?.enterprise?.enterpriseCode,
          "xmlSaleMovement": xml.replaceAll(RegExp(r'<'), '&lt;').replaceAll(RegExp(r'>'), '&gt;'),
        },
        typeOfResponse: "SendSaleMovementAsNFCeResponse",
        soapAction: "SendSaleMovementAsNFCe",
        serviceASMX: "CeltaSaleMovementService.asmx",
        typeOfResult: "SendSaleMovementAsNFCeResult",
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
