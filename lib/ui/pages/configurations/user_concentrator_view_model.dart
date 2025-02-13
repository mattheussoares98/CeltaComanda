import 'package:equatable/equatable.dart';

class UserConcentratorViewModel extends Equatable {
  final String?
      Name; //need only this property because use this view model only to select the user name
  // final String? UserId;
  // final String? InternalCodeOnERP;
  // final String? PersonalizedCode;
  // final String? Group;
  // final String? Password;
  // final String? PasswordMd5;
  // final String? DigitalPassword;
  // final String? IsAdm;
  // final String? IsExcluded; //TODO test is returning excluded users
  // final String? IsAlterPassword;
  // final List<GroupUserConcentratorModel>? Groups;
  // final List<EnterpriseConcentradorModel>? Enterprises;

  const UserConcentratorViewModel({required this.Name});

  @override
  List<Object?> get props => [Name];
}
