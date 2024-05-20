import '../../ui/helpers/helpers.dart';
import '../../domain/entities/entities.dart';

class EnterpriseValidationModel {
  final String enterpriseName;
  final String? url;
  final int? enterpriseId;
  final String? concentradorUrl;

  EnterpriseValidationModel({
    required this.enterpriseName,
    required this.url,
    required this.enterpriseId,
    required this.concentradorUrl,
  });

  factory EnterpriseValidationModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'url',
      'enterpriseId',
      'enterpriseName',
      'concentradorUrl',
    ])) {
      throw Exception();
    }
    return EnterpriseValidationModel(
      url: json['url'],
      enterpriseName: json["enterpriseName"],
      enterpriseId: json["enterpriseId"],
      concentradorUrl: json["concentradorUrl"],
    );
  }

  factory EnterpriseValidationModel.fromEntity(EnterpriseEntity entity) =>
      EnterpriseValidationModel(
        url: entity.url,
        enterpriseName: entity.enterpriseName,
        enterpriseId: entity.enterpriseId,
        concentradorUrl: entity.concentradorUrl,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
      enterpriseName: enterpriseName.toLowerCase().removeWhiteSpaces(),
      url: url?.toLowerCase().removeWhiteSpaces(),
      enterpriseId: enterpriseId,
      concentradorUrl: concentradorUrl?.toLowerCase().removeWhiteSpaces());

  Map<String, dynamic> toJson() => {
        'enterpriseName': enterpriseName.toLowerCase().removeWhiteSpaces(),
        'enterpriseId': enterpriseId,
        'url': url?.toLowerCase().removeWhiteSpaces(),
        'concentradorUrl': concentradorUrl?.toLowerCase().removeWhiteSpaces(),
      };
}
