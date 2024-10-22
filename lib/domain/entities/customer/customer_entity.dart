// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import 'customer.dart';

class CustomerEntity extends Equatable {
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
  final List<TelephoneEntity>? Telephones;
  final List<AddressEntity>? Addresses;
  final List<CovenantEntity>? CustomerCovenants;

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
}
