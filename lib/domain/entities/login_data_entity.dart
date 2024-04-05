import 'package:equatable/equatable.dart';

class LoginDataEntity extends Equatable {
  final String userName;
  final String url;

  const LoginDataEntity({
    required this.url,
    required this.userName,
  });

  @override
  List<Object?> get props => [url, userName];
}
