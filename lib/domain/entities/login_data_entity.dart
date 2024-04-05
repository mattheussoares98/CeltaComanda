import 'package:equatable/equatable.dart';

class LoginDataEntity extends Equatable {
  final String userName;
  final String url;

  const LoginDataEntity({
    required this.url,
    required this.userName,
  });

  @override
  List get props => [url, userName];
}
