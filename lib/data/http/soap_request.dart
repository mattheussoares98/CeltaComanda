import '../../infra/helpers/helpers.dart';

abstract class SoapRequest {
  Future<SoapResponse> post({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
  });
}
