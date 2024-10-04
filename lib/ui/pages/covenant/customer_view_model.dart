// ignore_for_file: non_constant_identifier_names

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
  final List<String>? Emails;
  final List<TelephoneModel>? Telephones;
  final List<AddressModel>? Addresses;
  final List<CovenantModel>? Covenants;

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
    required this.Emails,
    required this.Telephones,
    required this.Addresses,
    required this.Covenants,
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
        Emails,
        Telephones,
        Addresses,
        Covenants,
      ];

  factory CustomerViewModel.fromJson(Map json) => CustomerViewModel(
        Code: json["Code"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        ReducedName: json["ReducedName"],
        CpfCnpjNumber: json["CpfCnpjNumber"],
        RegistrationNumber: json["RegistrationNumber"],
        DateOfBirth: json["DateOfBirth"],
        SexType: json["SexType"],
        PersonType: json["PersonType"],
        Emails: json["Emails"].map<String>((e) => e.toString()).toList(),
        Telephones: json["Telephones"]
            .map<TelephoneModel>((e) => TelephoneModel.fromJson(e))
            .toList(),
        Addresses: json["Addresses"]
            .map<AddressModel>((e) => AddressModel.fromJson(e))
            .toList(),
        Covenants: json["Covenants"]
            .map<CovenantModel>((e) => CovenantModel.fromJson(e))
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
        "Emails": Emails,
        "Telephones": Telephones,
        "Addresses": Addresses,
        "Covenants": Covenants,
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
        Telephones: entity.Telephones?.map((e) => TelephoneModel.fromEntity(e))
            .toList(),
        Addresses:
            entity.Addresses?.map((e) => AddressModel.fromEntity(e)).toList(),
        Covenants:
            entity.Covenants?.map((e) => CovenantModel.fromEntity(e)).toList(),
      );
}
