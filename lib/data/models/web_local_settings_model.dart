import '../../domain/entities/entities.dart';

class WebLocalSettingsModel {
  final int? enterpriseId;
  final String? concentratorUrl;
  final String? enteprisePersonalizedCode;

  WebLocalSettingsModel({
    required this.enterpriseId,
    required this.concentratorUrl,
    required this.enteprisePersonalizedCode,
  });

  factory WebLocalSettingsModel.fromJson(Map<String, dynamic> json) =>
      WebLocalSettingsModel(
        enterpriseId: json['enterpriseId'],
        concentratorUrl: json['concentratorUrl'],
        enteprisePersonalizedCode: json['enteprisePersonalizedCode'],
      );

  Map<String, dynamic> toJson() => {
        'enterpriseId': enterpriseId,
        'concentratorUrl': concentratorUrl,
        'enteprisePersonalizedCode': enteprisePersonalizedCode,
      };

  factory WebLocalSettingsModel.fromEntity(WebLocalSettingsEntity entity) =>
      WebLocalSettingsModel(
        enterpriseId: entity.enterpriseId,
        concentratorUrl: entity.concentratorUrl,
        enteprisePersonalizedCode: entity.enteprisePersonalizedCode,
      );

  WebLocalSettingsEntity toEntity() => WebLocalSettingsEntity(
        enterpriseId: enterpriseId,
        concentratorUrl: concentratorUrl,
        enteprisePersonalizedCode: enteprisePersonalizedCode,
      );
}
