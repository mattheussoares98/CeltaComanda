import '../entities/entities.dart';

import 'package:equatable/equatable.dart';

abstract class Authentication {
  Future<CrossIdEntity?> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String user;
  final String password;
  final String urlCcs;

  @override
  List get props => [user, password, urlCcs];

  const AuthenticationParams({
    required this.user,
    required this.password,
    required this.urlCcs,
  });
}
