import '../../domain/entities/entities.dart';

class WebLocalSettingsModel {
  final int? enterpriseId;
  final String? concentratorUrl;
  final String? navsApi;
  final String? enteprisePersonalizedCode;

  WebLocalSettingsModel({
    required this.enterpriseId,
    required this.concentratorUrl,
    required this.navsApi,
    required this.enteprisePersonalizedCode,
  });

  factory WebLocalSettingsModel.fromJson(Map<String, dynamic> json) =>
      WebLocalSettingsModel(
        enterpriseId: json['enterpriseId'],
        concentratorUrl: json['concentratorUrl'],
        navsApi: json['navsApi'],
        enteprisePersonalizedCode: json['enteprisePersonalizedCode'],
      );

  Map<String, dynamic> toJson() => {
        'enterpriseId': enterpriseId,
        'concentratorUrl': concentratorUrl,
        'navsApi': navsApi,
        'enteprisePersonalizedCode': enteprisePersonalizedCode,
      };

  factory WebLocalSettingsModel.fromEntity(WebLocalSettingsEntity entity) =>
      WebLocalSettingsModel(
        enterpriseId: entity.enterpriseId,
        concentratorUrl: entity.concentratorUrl,
        navsApi: entity.navsApi,
        enteprisePersonalizedCode: entity.enteprisePersonalizedCode,
      );

  WebLocalSettingsEntity toEntity() => WebLocalSettingsEntity(
        enterpriseId: enterpriseId,
        concentratorUrl: concentratorUrl,
        navsApi: navsApi,
        enteprisePersonalizedCode: enteprisePersonalizedCode,
      );
}
