import 'dart:convert';

import '../../../../domain/entities/entities.dart';
import '../../../../domain/helpers/helpers.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/builders/builders.dart';
import '../../../http/http.dart';
import '../../../models/customer/customer.dart';

class RemoteLoadCustomer implements LoadCustomer {
  final SoapRequest soapAdapter;
  RemoteLoadCustomer({required this.soapAdapter});

  @override
  Future<List<CustomerEntity>?> load({
    required String value,
    required int searchTypeInt,
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
      final soapResponse = await soapAdapter.post(
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

      final List decoded = json.decode(soapResponse.response);

      return decoded.map((e) => CustomerModel.fromJson(e).toEntity()).toList();
    } catch (e) {
      return null;
    }
  }
}
