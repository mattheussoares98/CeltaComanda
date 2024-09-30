import '../../domain/entities/entities.dart';

class EnterpriseConcentradorModel {
  int? enterpriseId;
  String? cnpj;
  String? formatedCnpj;
  String? inscriptionState;
  String? passwordMonth;
  String? fantasyName;
  String? socialName;
  String? addressName;
  String? addressDistrict;
  String? addressCity;
  String? addressIBGECityCode;
  String? addressZip;
  String? addressState;
  String? nFCeIdentificationCode;
  String? nFCeSecurityCode;
  String? urlSefazConsultNfce;
  String? urlSefazConsultQRCodeNfce;
  String? addressFull;
  int? enterpriseCode;
  String? personalizedCode;
  String? telephone;
  int? federalSimpleType;
  bool? considerIcmsForCalculateBaseOfPisCofins;
  bool? saleInRetail;
  bool? saleInWholeSale;
  bool? saleInECommerce;
  String? enterpriseString;

  EnterpriseConcentradorModel({
    required this.enterpriseId,
    required this.cnpj,
    required this.formatedCnpj,
    required this.inscriptionState,
    required this.passwordMonth,
    required this.fantasyName,
    required this.socialName,
    required this.addressName,
    required this.addressDistrict,
    required this.addressCity,
    required this.addressIBGECityCode,
    required this.addressZip,
    required this.addressState,
    required this.nFCeIdentificationCode,
    required this.nFCeSecurityCode,
    required this.urlSefazConsultNfce,
    required this.urlSefazConsultQRCodeNfce,
    required this.addressFull,
    required this.enterpriseCode,
    required this.personalizedCode,
    required this.telephone,
    required this.federalSimpleType,
    required this.considerIcmsForCalculateBaseOfPisCofins,
    required this.saleInRetail,
    required this.saleInWholeSale,
    required this.saleInECommerce,
    required this.enterpriseString,
  });

  factory EnterpriseConcentradorModel.fromJson(Map<String, dynamic> json) =>
      EnterpriseConcentradorModel(
        enterpriseId: json['EnterpriseId'],
        cnpj: json['Cnpj'],
        formatedCnpj: json['FormatedCnpj'],
        inscriptionState: json['InscriptionState'],
        passwordMonth: json['PasswordMonth'],
        fantasyName: json['FantasyName'],
        socialName: json['SocialName'],
        addressName: json['AddressName'],
        addressDistrict: json['AddressDistrict'],
        addressCity: json['AddressCity'],
        addressIBGECityCode: json['AddressIBGECityCode'],
        addressZip: json['AddressZip'],
        addressState: json['AddressState'],
        nFCeIdentificationCode: json['NFCeIdentificationCode'],
        nFCeSecurityCode: json['NFCeSecurityCode'],
        urlSefazConsultNfce: json['UrlSefazConsultNfce'],
        urlSefazConsultQRCodeNfce: json['UrlSefazConsultQRCodeNfce'],
        addressFull: json['AddressFull'],
        enterpriseCode: json['EnterpriseCode'],
        personalizedCode: json['PersonalizedCode'],
        telephone: json['Telephone'],
        federalSimpleType: json['FederalSimpleType'],
        considerIcmsForCalculateBaseOfPisCofins:
            json['ConsiderIcmsForCalculateBaseOfPisCofins'],
        saleInRetail: json['SaleInRetail'],
        saleInWholeSale: json['SaleInWholeSale'],
        saleInECommerce: json['SaleInECommerce'],
        enterpriseString: json['EnterpriseString'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['EnterpriseId'] = enterpriseId;
    data['Cnpj'] = cnpj;
    data['FormatedCnpj'] = formatedCnpj;
    data['InscriptionState'] = inscriptionState;
    data['PasswordMonth'] = passwordMonth;
    data['FantasyName'] = fantasyName;
    data['SocialName'] = socialName;
    data['AddressName'] = addressName;
    data['AddressDistrict'] = addressDistrict;
    data['AddressCity'] = addressCity;
    data['AddressIBGECityCode'] = addressIBGECityCode;
    data['AddressZip'] = addressZip;
    data['AddressState'] = addressState;
    data['NFCeIdentificationCode'] = nFCeIdentificationCode;
    data['NFCeSecurityCode'] = nFCeSecurityCode;
    data['UrlSefazConsultNfce'] = urlSefazConsultNfce;
    data['UrlSefazConsultQRCodeNfce'] = urlSefazConsultQRCodeNfce;
    data['AddressFull'] = addressFull;
    data['EnterpriseCode'] = enterpriseCode;
    data['PersonalizedCode'] = personalizedCode;
    data['Telephone'] = telephone;
    data['FederalSimpleType'] = federalSimpleType;
    data['ConsiderIcmsForCalculateBaseOfPisCofins'] =
        considerIcmsForCalculateBaseOfPisCofins;
    data['SaleInRetail'] = saleInRetail;
    data['SaleInWholeSale'] = saleInWholeSale;
    data['SaleInECommerce'] = saleInECommerce;
    data['EnterpriseString'] = enterpriseString;
    return data;
  }

  factory EnterpriseConcentradorModel.fromEntity(
          EnterpriseConcentradorEntity entity) =>
      EnterpriseConcentradorModel(
        enterpriseId: entity.enterpriseId,
        cnpj: entity.cnpj,
        formatedCnpj: entity.formatedCnpj,
        inscriptionState: entity.inscriptionState,
        passwordMonth: entity.passwordMonth,
        fantasyName: entity.fantasyName,
        socialName: entity.socialName,
        addressName: entity.addressName,
        addressDistrict: entity.addressDistrict,
        addressCity: entity.addressCity,
        addressIBGECityCode: entity.addressIBGECityCode,
        addressZip: entity.addressZip,
        addressState: entity.addressState,
        nFCeIdentificationCode: entity.nFCeIdentificationCode,
        nFCeSecurityCode: entity.nFCeSecurityCode,
        urlSefazConsultNfce: entity.urlSefazConsultNfce,
        urlSefazConsultQRCodeNfce: entity.urlSefazConsultQRCodeNfce,
        addressFull: entity.addressFull,
        enterpriseCode: entity.enterpriseCode,
        personalizedCode: entity.personalizedCode,
        telephone: entity.telephone,
        federalSimpleType: entity.federalSimpleType,
        considerIcmsForCalculateBaseOfPisCofins:
            entity.considerIcmsForCalculateBaseOfPisCofins,
        saleInRetail: entity.saleInRetail,
        saleInWholeSale: entity.saleInWholeSale,
        saleInECommerce: entity.saleInECommerce,
        enterpriseString: entity.enterpriseString,
      );

  EnterpriseConcentradorEntity toEntity() => EnterpriseConcentradorEntity(
        enterpriseId: enterpriseId,
        cnpj: cnpj,
        formatedCnpj: formatedCnpj,
        inscriptionState: inscriptionState,
        passwordMonth: passwordMonth,
        fantasyName: fantasyName,
        socialName: socialName,
        addressName: addressName,
        addressDistrict: addressDistrict,
        addressCity: addressCity,
        addressIBGECityCode: addressIBGECityCode,
        addressZip: addressZip,
        addressState: addressState,
        nFCeIdentificationCode: nFCeIdentificationCode,
        nFCeSecurityCode: nFCeSecurityCode,
        urlSefazConsultNfce: urlSefazConsultNfce,
        urlSefazConsultQRCodeNfce: urlSefazConsultQRCodeNfce,
        addressFull: addressFull,
        enterpriseCode: enterpriseCode,
        personalizedCode: personalizedCode,
        telephone: telephone,
        federalSimpleType: federalSimpleType,
        considerIcmsForCalculateBaseOfPisCofins:
            considerIcmsForCalculateBaseOfPisCofins,
        saleInRetail: saleInRetail,
        saleInWholeSale: saleInWholeSale,
        saleInECommerce: saleInECommerce,
        enterpriseString: enterpriseString,
      );
}
