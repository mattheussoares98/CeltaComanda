import 'package:equatable/equatable.dart';

class LoginDataEntity extends Equatable {
  final String userName;
  final String url;
  final String? enterpriseName;

  const LoginDataEntity({
    required this.url,
    required this.userName,
    this.enterpriseName,
  });

  @override
  List get props => [url, userName, enterpriseName];
}
