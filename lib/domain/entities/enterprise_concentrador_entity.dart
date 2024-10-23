import 'package:equatable/equatable.dart';

class EnterpriseConcentradorEntity extends Equatable {
  final int? enterpriseId;
  final int? enterpriseCode;
  final int? federalSimpleType;
  final String? cnpj;
  final String? formatedCnpj;
  final String? inscriptionState;
  final String? passwordMonth;
  final String? fantasyName;
  final String? socialName;
  final String? addressName;
  final String? addressDistrict;
  final String? addressCity;
  final String? addressIBGECityCode;
  final String? addressZip;
  final String? addressState;
  final String? nFCeIdentificationCode;
  final String? nFCeSecurityCode;
  final String? urlSefazConsultNfce;
  final String? urlSefazConsultQRCodeNfce;
  final String? addressFull;
  final String? personalizedCode;
  final String? telephone;
  final String? enterpriseString;
  final bool? considerIcmsForCalculateBaseOfPisCofins;
  final bool? saleInRetail;
  final bool? saleInWholeSale;
  final bool? saleInECommerce;

  const EnterpriseConcentradorEntity({
    required this.enterpriseId,
    required this.enterpriseCode,
    required this.federalSimpleType,
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
    required this.personalizedCode,
    required this.telephone,
    required this.enterpriseString,
    required this.considerIcmsForCalculateBaseOfPisCofins,
    required this.saleInRetail,
    required this.saleInWholeSale,
    required this.saleInECommerce,
  });

  @override
  List<Object?> get props => [
        enterpriseId,
        enterpriseCode,
        federalSimpleType,
        cnpj,
        formatedCnpj,
        inscriptionState,
        passwordMonth,
        fantasyName,
        socialName,
        addressName,
        addressDistrict,
        addressCity,
        addressIBGECityCode,
        addressZip,
        addressState,
        nFCeIdentificationCode,
        nFCeSecurityCode,
        urlSefazConsultNfce,
        urlSefazConsultQRCodeNfce,
        addressFull,
        personalizedCode,
        telephone,
        enterpriseString,
        considerIcmsForCalculateBaseOfPisCofins,
        saleInRetail,
        saleInWholeSale,
        saleInECommerce,
      ];
}
