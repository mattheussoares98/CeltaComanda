// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/customer/customer.dart';
import '../../../domain/entities/entities.dart';

class CustomerViewModel extends Equatable {
  final String? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? ReducedName;
  final String? CpfCnpjNumber;
  final String? RegistrationNumber;
  final String? DateOfBirth;
  final String? SexType;
  final String? PersonType;
  final String? HasPassword;
  final List<String>? Emails;
  final List<TelephoneModel>? Telephones;
  final List<AddressModel>? Addresses;
  final List<CovenantModel>? CustomerCovenants;

  const CustomerViewModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.ReducedName,
    required this.CpfCnpjNumber,
    required this.RegistrationNumber,
    required this.DateOfBirth,
    required this.SexType,
    required this.PersonType,
    required this.HasPassword,
    required this.Emails,
    required this.Telephones,
    required this.Addresses,
    required this.CustomerCovenants,
  });
  @override
  List<Object?> get props => [
        Code,
        PersonalizedCode,
        Name,
        ReducedName,
        CpfCnpjNumber,
        RegistrationNumber,
        DateOfBirth,
        SexType,
        PersonType,
        HasPassword,
        Emails,
        Telephones,
        Addresses,
        CustomerCovenants,
      ];

  factory CustomerViewModel.fromJson(Map json) => CustomerViewModel(
        Code: json["Code"]?.toString(),
        PersonalizedCode: json["PersonalizedCode"]?.toString(),
        Name: json["Name"]?.toString(),
        ReducedName: json["ReducedName"]?.toString(),
        CpfCnpjNumber: json["CpfCnpjNumber"]?.toString(),
        RegistrationNumber: json["RegistrationNumber"]?.toString(),
        DateOfBirth: json["DateOfBirth"]?.toString(),
        SexType: json["SexType"]?.toString(),
        PersonType: json["PersonType"]?.toString(),
        HasPassword: json["HasPassword"]?.toString(),
        Emails: json["Emails"].map<String>((e) => e.toString()).toList(),
        Telephones: json["Telephones"]
            ?.map<TelephoneModel>((e) => TelephoneModel.fromJson(e))
            .toList(),
        Addresses: json["Addresses"]
            ?.map<AddressModel>((e) => AddressModel.fromJson(e))
            .toList(),
        CustomerCovenants: json["CustomerCovenants"]
            ?.map<CovenantModel>((e) => CovenantModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "ReducedName": ReducedName,
        "CpfCnpjNumber": CpfCnpjNumber,
        "RegistrationNumber": RegistrationNumber,
        "DateOfBirth": DateOfBirth,
        "SexType": SexType,
        "PersonType": PersonType,
        "HasPassword": HasPassword,
        "Emails": Emails,
        "Telephones": Telephones,
        "Addresses": Addresses,
        "CustomerCovenants": CustomerCovenants,
      };

  factory CustomerViewModel.fromEntity(CustomerEntity entity) =>
      CustomerViewModel(
        Code: entity.Code.toString(),
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.Name,
        ReducedName: entity.ReducedName,
        CpfCnpjNumber: entity.CpfCnpjNumber,
        RegistrationNumber: entity.RegistrationNumber,
        DateOfBirth: entity.DateOfBirth,
        SexType: entity.SexType,
        PersonType: entity.PersonType,
        Emails: entity.Emails,
        HasPassword: entity.HasPassword == true ? "true" : "false",
        Telephones: entity.Telephones?.map((e) => TelephoneModel.fromEntity(e))
            .toList(),
        Addresses:
            entity.Addresses?.map((e) => AddressModel.fromEntity(e)).toList(),
        CustomerCovenants:
            entity.CustomerCovenants?.map((e) => CovenantModel.fromEntity(e))
                .toList(),
      );

  CustomerEntity toEntity() => CustomerEntity(
        Code: Code!.toInt(),
        PersonalizedCode: PersonalizedCode,
        Name: Name,
        ReducedName: ReducedName,
        CpfCnpjNumber: CpfCnpjNumber,
        RegistrationNumber: RegistrationNumber,
        DateOfBirth: DateOfBirth,
        SexType: SexType,
        PersonType: PersonType,
        HasPassword: HasPassword == "true",
        Emails: Emails,
        Telephones: Telephones?.map((e) => e.toEntity()).toList(),
        Addresses: Addresses?.map((e) => e.toEntity()).toList(),
        CustomerCovenants: CustomerCovenants?.map((e) => e.toEntity()).toList(),
      );
}
