import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/http/http.dart';

class RemoteLoadCustomer implements LoadCustomer {
  final SoapAdapter soapAdapter;
  RemoteLoadCustomer({required this.soapAdapter});

  @override
  Future<void> load(String value) async {
    try {
      await soapAdapter.post(
        parameters: {
          "filters": json.encode({
            // "crossIdentity": UserData.crossIdentity,
            // "customerData": value,
            // "customerDataType": searchTypeInt,
            // "enterpriseCode": enterpriseCode,
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
