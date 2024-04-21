import 'package:equatable/equatable.dart';

class EnterpriseEntity extends Equatable {
  final String enterpriseName;
  final String? url;
  final int? enterpriseId;

  const EnterpriseEntity({
    required this.enterpriseName,
    this.url,
    this.enterpriseId,
  });

  @override
  List get props => [url, enterpriseName, enterpriseId];
}
