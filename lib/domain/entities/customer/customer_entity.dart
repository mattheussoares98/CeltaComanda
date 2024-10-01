// ignore_for_file: non_constant_identifier_names

import 'customer.dart';

class CustomerEntity {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final String ReducedName;
  final String CpfCnpjNumber;
  final String RegistrationNumber;
  final String DateOfBirth;
  final String SexType;
  final String PersonType;
  final List<String> Emails;
  final List<TelephoneEntity> Telephones;
  final List<AddressEntity> Addresses;
  final dynamic Covenants;

  const CustomerEntity({
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
}
