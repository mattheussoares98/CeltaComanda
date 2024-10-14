class GetNetModel {
  final String? amount;
  final String? authorizationCode;
  final String? orderId;
  final String? gmtDateTime;
  final String? automationSlip;
  final String? type;
  final String? nsuLocal;
  final String? cvNumber;
  final String? result;
  final String? resultDetails;
  final String? nsu;
  final String? extraScreensResult;
  final String? pixPayloadResponse;
  final String? cardBin;
  final String? installments;
  final String? cardholderName;
  final String? inputType;
  final String? callerId;
  final String? brand;
  final String? nsuLastSuccesfullMessage;
  final String? cardLastDigits;

  const GetNetModel({
    required this.amount,
    required this.authorizationCode,
    required this.orderId,
    required this.gmtDateTime,
    required this.automationSlip,
    required this.type,
    required this.nsuLocal,
    required this.cvNumber,
    required this.result,
    required this.resultDetails,
    required this.nsu,
    required this.extraScreensResult,
    required this.pixPayloadResponse,
    required this.cardBin,
    required this.installments,
    required this.cardholderName,
    required this.inputType,
    required this.callerId,
    required this.brand,
    required this.nsuLastSuccesfullMessage,
    required this.cardLastDigits,
  });

  factory GetNetModel.fromJson(Map json) => GetNetModel(
        amount: json["amount"],
        authorizationCode: json["authorizationCode"],
        orderId: json["orderId"],
        gmtDateTime: json["gmtDateTime"],
        automationSlip: json["automationSlip"],
        type: json["type"],
        nsuLocal: json["nsuLocal"],
        cvNumber: json["cvNumber"],
        result: json["result"],
        resultDetails: json["resultDetails"],
        nsu: json["nsu"],
        extraScreensResult: json["extraScreensResult"],
        pixPayloadResponse: json["pixPayloadResponse"],
        cardBin: json["cardBin"],
        installments: json["installments"],
        cardholderName: json["cardholderName"],
        inputType: json["inputType"],
        callerId: json["callerId"],
        brand: json["brand"],
        nsuLastSuccesfullMessage: json["nsuLastSuccesfullMessage"],
        cardLastDigits: json["cardLastDigits"],
      );

  Map<String, String?> toJson() => {
        "amount": amount,
        "authorizationCode": authorizationCode,
        "orderId": orderId,
        "gmtDateTime": gmtDateTime,
        "automationSlip": automationSlip,
        "type": type,
        "nsuLocal": nsuLocal,
        "cvNumber": cvNumber,
        "result": result,
        "resultDetails": resultDetails,
        "nsu": nsu,
        "extraScreensResult": extraScreensResult,
        "pixPayloadResponse": pixPayloadResponse,
        "cardBin": cardBin,
        "installments": installments,
        "cardholderName": cardholderName,
        "inputType": inputType,
        "callerId": callerId,
        "brand": brand,
        "nsuLastSuccesfullMessage": nsuLastSuccesfullMessage,
        "cardLastDigits": cardLastDigits,
      };
}
