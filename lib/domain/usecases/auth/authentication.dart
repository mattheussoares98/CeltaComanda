import 'package:equatable/equatable.dart';

abstract class Authentication {
  Future<void> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String user;
  final String password;
  final String url;

  @override
  List get props => [user, password, url];

  const AuthenticationParams({
    required this.user,
    required this.password,
    required this.url,
  });
}
