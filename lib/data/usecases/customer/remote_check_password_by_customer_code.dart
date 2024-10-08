import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteCheckPasswordByCustomerCode implements CheckPasswordByCustomerCode {
  final SoapRequest soapAdapter;
  RemoteCheckPasswordByCustomerCode({required this.soapAdapter});

  @override
  Future<bool> validate({
    required int customerCode,
    required String password,
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
          "crossIdentity": EnterpriseDataBuilder.enterpriseDataEntity!
              .enterpriseConcentradorParametersEntity!.celtaBSCrossIdentity,
          "customerCode": customerCode,
          "password": password,
        },
        typeOfResponse: "CheckPasswordByCustomerCodeResponse",
        soapAction: "CheckPasswordByCustomerCode",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "CheckPasswordByCustomerCodeResult",
      );

      debugPrint(soapResponse.response);
      return true;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
