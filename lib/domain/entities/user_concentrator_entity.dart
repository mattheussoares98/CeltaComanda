import 'package:equatable/equatable.dart';

import 'entities.dart';

class UserConcentratorEntity extends Equatable {
  final int? UserId;
  final int? InternalCodeOnERP;
  final String? PersonalizedCode;
  final String? Name;
  final String? Group;
  final String? Password;
  final String? PasswordMd5;
  final String? DigitalPassword;
  final bool? IsAdm;
  final bool? IsExcluded;
  final bool? IsAlterPassword;
  final List<GroupUserConcentratorEntity>? Groups;
  final List<EnterpriseConcentradorEntity>? Enterprises;

  const UserConcentratorEntity({
    required this.UserId,
    required this.InternalCodeOnERP,
    required this.PersonalizedCode,
    required this.Name,
    required this.Group,
    required this.Password,
    required this.PasswordMd5,
    required this.DigitalPassword,
    required this.IsAdm,
    required this.IsExcluded,
    required this.IsAlterPassword,
    required this.Groups,
    required this.Enterprises,
  });

  @override
  List<Object?> get props => [
        UserId,
        InternalCodeOnERP,
        PersonalizedCode,
        Name,
        Group,
        Password,
        PasswordMd5,
        DigitalPassword,
        IsAdm,
        IsExcluded,
        IsAlterPassword,
        Groups,
        Enterprises,
      ];
}
