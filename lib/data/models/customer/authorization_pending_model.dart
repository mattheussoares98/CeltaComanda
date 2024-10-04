import 'package:equatable/equatable.dart';

class AuthorizationPendingModel extends Equatable {
  final String code;
  final bool isPending;

  const AuthorizationPendingModel({
    required this.code,
    required this.isPending,
  });

  @override
  List<Object?> get props => [code, isPending];

  Map<String, dynamic> toJson() => {
        "code": code,
        "isPending": isPending,
      };

  factory AuthorizationPendingModel.fromJson(Map data) =>
      AuthorizationPendingModel(
        code: data["code"],
        isPending: data["isPending"],
      );
}
