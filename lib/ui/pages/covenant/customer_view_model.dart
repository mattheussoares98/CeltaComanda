// ignore_for_file: non_constant_identifier_names

import '../../../data/models/customer/customer.dart';

class CustomerViewModel {
  final String Code;
  final String PersonalizedCode;
  final String Name;
  final String ReducedName;
  final String CpfCnpjNumber;
  final String RegistrationNumber;
  final String DateOfBirth;
  final String SexType;
  final String PersonType;
  final List<String> Emails;
  final List<TelephoneModel> Telephones;
  final List<AddressModel> Addresses;
  final List<CovenantModel> Covenants;

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

  CustomerViewModel fromEntity() => CustomerViewModel(
        Code: Code,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
        ReducedName: ReducedName,
        CpfCnpjNumber: CpfCnpjNumber,
        RegistrationNumber: RegistrationNumber,
        DateOfBirth: DateOfBirth,
        SexType: SexType,
        PersonType: PersonType,
        Emails: Emails,
        Telephones: Telephones,
        Addresses: Addresses,
        Covenants: Covenants,
      );
}
