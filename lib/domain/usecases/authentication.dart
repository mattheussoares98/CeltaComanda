import '../entities/entities.dart';

import 'package:equatable/equatable.dart';

abstract class Authentication {
  Future<CrossIdEntity?> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String user;
  final String password;

  @override
  List get props => [user, password];

  const AuthenticationParams({required this.user, required this.password});
}
