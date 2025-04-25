class GetNetResponseModel {
  final String? amount;
  final bool? printMerchantPreference;
  final bool? partialAuthorization;
  final String? authorizationCode;
  final String? cardHolderName;
  final String? gmtDateTime;
  final AutomationSlipModel? automationSlip;
  final String? type;
  final String? nsuLocal;
  final String? cvNumber;
  final String? result;
  final String? nsu;
  final String? resultDetails;
  final String? cardBin;
  final String? inputType;
  final String? callerId;
  final String? brand;
  final String? nsuLastSuccesfullMessage;
  final String? cardLastDigits;

  GetNetResponseModel({
    required this.amount,
    required this.printMerchantPreference,
    required this.partialAuthorization,
    required this.authorizationCode,
    required this.cardHolderName,
    required this.gmtDateTime,
    required this.automationSlip,
    required this.type,
    required this.nsuLocal,
    required this.cvNumber,
    required this.result,
    required this.nsu,
    required this.resultDetails,
    required this.cardBin,
    required this.inputType,
    required this.callerId,
    required this.brand,
    required this.nsuLastSuccesfullMessage,
    required this.cardLastDigits,
  });

  factory GetNetResponseModel.fromJson(Map json) => GetNetResponseModel(
        amount: json['amount'],
        printMerchantPreference: json['printMerchantPreference'],
        partialAuthorization: json['partialAuthorization'],
        authorizationCode: json['authorizationCode'],
        cardHolderName: json['cardHolderName'],
        gmtDateTime: json['gmtDateTime'],
        automationSlip: json['automationSlip'] != null
            ? AutomationSlipModel.fromJson(json['automationSlip'])
            : null,
        type: json['type'],
        nsuLocal: json['nsuLocal'],
        cvNumber: json['cvNumber'],
        result: json['result'],
        nsu: json['nsu'],
        resultDetails: json['resultDetails'],
        cardBin: json['cardBin'],
        inputType: json['inputType'],
        callerId: json['callerId'],
        brand: json['brand'],
        nsuLastSuccesfullMessage: json['nsuLastSuccesfullMessage'],
        cardLastDigits: json['cardLastDigits'],
      );
}

class AutomationSlipModel {
  final MandatoryAllReceiptsFieldsModel? mandatoryAllReceiptsFields;
  final MandatoryClientFieldsModel? mandatoryClientFields;
  final MandatoryEcFieldsModel? mandatoryEcFields;

  AutomationSlipModel({
    required this.mandatoryAllReceiptsFields,
    required this.mandatoryClientFields,
    required this.mandatoryEcFields,
  });

  factory AutomationSlipModel.fromJson(Map json) => AutomationSlipModel(
        mandatoryAllReceiptsFields: MandatoryAllReceiptsFieldsModel.fromJson(
            json['mandatory_all_receipts_fields']),
        mandatoryClientFields: MandatoryClientFieldsModel.fromJson(
            json['mandatory_client_fields']),
        mandatoryEcFields:
            MandatoryEcFieldsModel.fromJson(json['mandatory_ec_fields']),
      );
}

class MandatoryAllReceiptsFieldsModel {
  final String? authorizationCode;
  final String? brand;
  final String? cardLastDigits;
  final String? city;
  final String? ecDocument;
  final String? ecName;
  final String? ecNumber;
  final String? letterTypeTransaction;
  final String? version;
  final String? getnetLogo;
  final String? dateTime;
  final String? nsu;
  final String? terminal;

  MandatoryAllReceiptsFieldsModel({
    required this.authorizationCode,
    required this.brand,
    required this.cardLastDigits,
    required this.city,
    required this.ecDocument,
    required this.ecName,
    required this.ecNumber,
    required this.letterTypeTransaction,
    required this.version,
    required this.getnetLogo,
    required this.dateTime,
    required this.nsu,
    required this.terminal,
  });

  factory MandatoryAllReceiptsFieldsModel.fromJson(Map json) =>
      MandatoryAllReceiptsFieldsModel(
        authorizationCode: json['authorizationCode'],
        brand: json['brand'],
        cardLastDigits: json['cardLastDigits'],
        city: json['city'],
        ecDocument: json['ecDocument'],
        ecName: json['ecName'],
        ecNumber: json['ecNumber'],
        letterTypeTransaction: json['letterTypeTransaction'],
        version: json['version'],
        getnetLogo: json['getnetLogo'],
        dateTime: json['dateTime'],
        nsu: json['nsu'],
        terminal: json['terminal'],
      );
}

class MandatoryClientFieldsModel {
  final String? clientBody;
  final String? receiptTypeClient;

  MandatoryClientFieldsModel({
    required this.clientBody,
    required this.receiptTypeClient,
  });

  factory MandatoryClientFieldsModel.fromJson(Map json) =>
      MandatoryClientFieldsModel(
        clientBody: json['clientBody'],
        receiptTypeClient: json['receiptTypeClient'],
      );
}

class MandatoryEcFieldsModel {
  final String? aid;
  final String? arqc;
  final String? ecBody;
  final String? nsuLocal;
  final String? receiptTypeEc;

  MandatoryEcFieldsModel({
    required this.aid,
    required this.arqc,
    required this.ecBody,
    required this.nsuLocal,
    required this.receiptTypeEc,
  });

  factory MandatoryEcFieldsModel.fromJson(Map json) => MandatoryEcFieldsModel(
        aid: json['aid'],
        arqc: json['arqc'],
        ecBody: json['ecBody'],
        nsuLocal: json['nsuLocal'],
        receiptTypeEc: json['receiptTypeEc'],
      );
}
