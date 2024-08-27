import 'package:equatable/equatable.dart';

class EnterpriseEntity extends Equatable {
  final String enterpriseName;
  final String? url;
  final int? enterpriseId;
  final String? concentradorUrl;

  const EnterpriseEntity({
    required this.enterpriseName,
    required this.url,
    required this.enterpriseId,
    required this.concentradorUrl,
  });

  @override
  List get props => [url, enterpriseName, enterpriseId, concentradorUrl];
}
