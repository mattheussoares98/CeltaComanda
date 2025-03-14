import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import 'customer.dart';

class CustomerModel extends Equatable {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? ReducedName;
  final String? CpfCnpjNumber;
  final String? RegistrationNumber;
  final String? DateOfBirth;
  final String? SexType;
  final String? PersonType;
  final bool? HasPassword;
  final List<String>? Emails;
  final List<TelephoneModel>? Telephones;
  final List<AddressModel>? Addresses;
  final List<CovenantModel>? Covenants;

  const CustomerModel({
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
        HasPassword,
        Emails,
        Telephones,
        Addresses,
        Covenants,
      ];

  factory CustomerModel.fromJson(Map json) => CustomerModel(
        Code: json["Code"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        ReducedName: json["ReducedName"],
        CpfCnpjNumber: json["CpfCnpjNumber"],
        RegistrationNumber: json["RegistrationNumber"],
        DateOfBirth: json["DateOfBirth"],
        SexType: json["SexType"],
        PersonType: json["PersonType"],
        HasPassword: json["HasPassword"],
        Emails: json["Emails"].map<String>((e) => e.toString()).toList(),
        Telephones: json["Telephones"]
            .map<TelephoneModel>((e) => TelephoneModel.fromJson(e))
            .toList(),
        Addresses: json["Addresses"]
            .map<AddressModel>((e) => AddressModel.fromJson(e))
            .toList(),
        Covenants: json["Covenants"]
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
        "Covenants": Covenants,
      };

  CustomerEntity toEntity() => CustomerEntity(
        Code: Code,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
        ReducedName: ReducedName,
        CpfCnpjNumber: CpfCnpjNumber,
        RegistrationNumber: RegistrationNumber,
        DateOfBirth: DateOfBirth,
        SexType: SexType,
        PersonType: PersonType,
        HasPassword: HasPassword,
        Emails: Emails,
        Telephones: Telephones?.map((e) => e.toEntity()).toList(),
        Addresses: Addresses?.map((e) => e.toEntity()).toList(),
        CustomerCovenants: Covenants?.map((e) => e.toEntity()).toList(),
      );

  factory CustomerModel.fromViewModel(CustomerViewModel viewModel) =>
      CustomerModel(
        Code: viewModel.Code?.toInt(),
        PersonalizedCode: viewModel.PersonalizedCode,
        Name: viewModel.Name,
        ReducedName: viewModel.ReducedName,
        CpfCnpjNumber: viewModel.CpfCnpjNumber,
        RegistrationNumber: viewModel.RegistrationNumber,
        DateOfBirth: viewModel.DateOfBirth,
        SexType: viewModel.SexType,
        PersonType: viewModel.PersonType,
        HasPassword: viewModel.HasPassword == "true",
        Emails: viewModel.Emails,
        Telephones: viewModel.Telephones,
        Addresses: viewModel.Addresses,
        Covenants: viewModel.CustomerCovenants,
      );
}
