import 'dart:convert';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteLoadCustomer with ErrorHandling implements LoadCustomer {
  final SoapRequest soapAdapter;
  RemoteLoadCustomer({required this.soapAdapter});

  @override
  Future<dynamic> load({
    required String value,
    required bool searchByPersonalizedCode,
  }) async {
    try {
      if (EnterpriseBuilder.entity?.enterpriseConcentradorParametersEntity ==
              null ||
          EnterpriseBuilder.entity!.enterpriseConcentradorParametersEntity!
                  .celtaBSCrossIdentity!.isEmpty ==
              true) {
        throw Exception();
      } else if (value.isEmpty) {
        throw Exception();
      }

      int? valueInInt = int.tryParse(value);
      int? searchTypeInt;
      // 1=ExactCnpjCpfNumber
      // 2=ExactCode
      // 3=ApproximateName
      // 4=PersonalizedCode

      if (valueInInt == null) {
        searchTypeInt = 3;
      } else if (searchByPersonalizedCode) {
        searchTypeInt = 4;
      } else if (valueInInt.toString().length == 11 ||
          valueInInt.toString().length == 14) {
        searchTypeInt = 1;
      } else {
        searchTypeInt = 2;
      }

      final soapResponse = await soapAdapter.post(
        parameters: {
          "filters": json.encode({
            "crossIdentity": EnterpriseBuilder.entity!
                .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity,
            "customerData": value,
            "customerDataType": searchTypeInt,
            "enterpriseCode": EnterpriseBuilder.entity!.enterpriseId!,
          }),
        },
        typeOfResponse: "GetCustomerJsonResponse",
        soapAction: "GetCustomerJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCustomerJsonResult",
      );

      return soapResponse;
    } catch (e) {
      treatError(e);
    }
  }
}
