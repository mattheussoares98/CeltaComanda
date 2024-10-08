import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

import '../../data/http/http.dart';
import '../../domain/helpers/helpers.dart';
import '../../main/builders/builders.dart';
import '../helpers/helperts.dart';

class SoapAdapter implements SoapRequest {
  @override
  Future<SoapResponse> post({
    required Map<String, dynamic> parameters,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
  }) async {
    late SoapResponse soapResponse;

    try {
      final soapHeaders = {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://celtaware.com.br/$soapAction',
        'Accept-Language': 'en-US',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
      };

      String parameterTags = '';

      parameters.forEach((tag, value) {
        parameterTags += '<$tag>$value</$tag>\n';
      });

      final envelope = '''<?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <$soapAction xmlns="http://celtaware.com.br/">
          $parameterTags
          </$soapAction>
        </soap12:Body>
      </soap12:Envelope>''';

      final response = await http.post(
        Uri.parse(
            '${EnterpriseDataBuilder.enterpriseDataEntity!.urlCCS}/$serviceASMX'),
        headers: soapHeaders,
        body: envelope,
      );

      if (response.statusCode == 200) {
        String result = response.body;

        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(result);
        final getJustificationsResult = xml2json.toParker();
        Map<String, dynamic> parsedJson =
            json.decode(getJustificationsResult.toString());

        if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                ["status"] ==
            "OK") {
          if (typeOfResult != null) {
            if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                    [typeOfResult] !=
                null) {
              soapResponse = SoapResponse(
                response: parsedJson["soap:Envelope"]["soap:Body"]
                        [typeOfResponse][typeOfResult]
                    .toString(),
                responseType: SoapResponseType.success,
              );
            }

            if (_validateResultHasPatternNewDataSet(
              parsedJson: parsedJson,
              typeOfResponse: typeOfResponse,
              typeOfResult: typeOfResult,
            )) {
              soapResponse = SoapResponse(
                response: parsedJson["soap:Envelope"]["soap:Body"]
                            [typeOfResponse][typeOfResult]["diffgr:diffgram"]
                        ["NewDataSet"]
                    .toString(),
                responseType: SoapResponseType.success,
              );
            }
          }
        } else {
          if (parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
              .toString()
              .contains("sucesso")) {
            soapResponse = SoapResponse(
              response: parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                  ["status"][typeOfResult],
              responseType: SoapResponseType.success,
            );
          } else {
            soapResponse = SoapResponse(
              response: parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
                  ["status"],
              responseType: SoapResponseType.error,
            );
          }
        }
      } else {
        throw DomainError.unexpected;
      }
      return soapResponse;
    } catch (e) {
      rethrow;
    }
  }
}

bool _validateResultHasPatternNewDataSet({
  required Map parsedJson,
  required String typeOfResponse,
  required String typeOfResult,
}) {
  return parsedJson.containsKey("soap:Envelope") &&
      parsedJson["soap:Envelope"] is Map &&
      parsedJson["soap:Envelope"].containsKey("soap:Body") &&
      parsedJson["soap:Envelope"]["soap:Body"] is Map &&
      parsedJson["soap:Envelope"]["soap:Body"].containsKey(typeOfResponse) &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse] is Map &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse]
          .containsKey(typeOfResult) &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
          is Map &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
          .containsKey("diffgr:diffgram") &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
          ["diffgr:diffgram"] is Map &&
      parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse][typeOfResult]
              ["diffgr:diffgram"]
          .containsKey("NewDataSet");
}
