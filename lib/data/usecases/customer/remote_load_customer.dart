import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadCustomer implements LoadCustomer {
  final SoapRequest soapAdapter;
  RemoteLoadCustomer({required this.soapAdapter});

  @override
  Future<void> load({
    required String value,
    required int searchTypeInt,
  }) async {
    try {
      /* final jsonData =  */ await soapAdapter.post(
        parameters: {
          "filters": json.encode({
            "crossIdentity": EnterpriseDataBuilder.enterpriseDataEntity!
                .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity,
            "customerData": value,
            "customerDataType": searchTypeInt,
            "enterpriseCode":
                EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId!,
          }),
        },
        typeOfResponse: "GetCustomerJsonResponse",
        soapAction: "GetCustomerJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCustomerJsonResult",
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
