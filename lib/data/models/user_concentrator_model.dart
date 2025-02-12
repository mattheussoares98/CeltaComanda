import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class UserConcentratorModel extends Equatable {
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
  final List<GroupUserConcentratorModel>? Groups;
  final List<EnterpriseConcentradorModel>? Enterprises;

  const UserConcentratorModel({
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

  factory UserConcentratorModel.fromJson(Map json) => UserConcentratorModel(
        UserId: json["UserId"],
        InternalCodeOnERP: json["InternalCodeOnERP"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        Group: json["Group"],
        Password: json["Password"],
        PasswordMd5: json["PasswordMd5"],
        DigitalPassword: json["DigitalPassword"],
        IsAdm: json["IsAdm"],
        IsExcluded: json["IsExcluded"],
        IsAlterPassword: json["IsAlterPassword"],
        Groups: json["Groups"] == null
            ? null
            : (json["Groups"] as List)
                .map((e) => GroupUserConcentratorModel.fromJson(e))
                .toList(),
        Enterprises: json["Enterprises"] == null
            ? null
            : (json["Enterprises"] as List)
                .map((e) => EnterpriseConcentradorModel.fromJson(e))
                .toList(),
      );

  UserConcentratorEntity toEntity() => UserConcentratorEntity(
        UserId: UserId,
        InternalCodeOnERP: InternalCodeOnERP,
        PersonalizedCode: PersonalizedCode,
        Name: Name,
        Group: Group,
        Password: Password,
        PasswordMd5: PasswordMd5,
        DigitalPassword: DigitalPassword,
        IsAdm: IsAdm,
        IsExcluded: IsExcluded,
        IsAlterPassword: IsAlterPassword,
        Groups: Groups?.map((e) => e.toEntity()).toList(),
        Enterprises: Enterprises?.map((e) => e.toEntity()).toList(),
      );
}
