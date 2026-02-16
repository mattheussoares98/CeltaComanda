import '../../domain/entities/entities.dart';

class WebLocalSettingsModel {
  final int? enterpriseId;
  final int concentratorPort;
  final int navsPort;
  final String defaultUrl;
  final String? enteprisePersonalizedCode;

  WebLocalSettingsModel({
    required this.enterpriseId,
    required this.concentratorPort,
    required this.navsPort,
    required this.defaultUrl,
    required this.enteprisePersonalizedCode,
  });

  factory WebLocalSettingsModel.fromJson(
          Map<String, dynamic> json, String defaultUrl) =>
      WebLocalSettingsModel(
        enterpriseId: json['enterpriseId'],
        concentratorPort: json['concentratorPort'],
        defaultUrl: defaultUrl,
        navsPort: json['navsPort'],
        enteprisePersonalizedCode: json['enteprisePersonalizedCode'],
      );

  Map<String, dynamic> toJson() => {
        'enterpriseId': enterpriseId,
        'concentratorPort': concentratorPort,
        'defaultUrl': defaultUrl,
        'navsPort': navsPort,
        'enteprisePersonalizedCode': enteprisePersonalizedCode,
      };

  factory WebLocalSettingsModel.fromEntity(WebLocalSettingsEntity entity) =>
      WebLocalSettingsModel(
        enterpriseId: entity.enterpriseId,
        concentratorPort: entity.concentratorPort,
        navsPort: entity.navsPort,
        defaultUrl: entity.defaultUrl,
        enteprisePersonalizedCode: entity.enteprisePersonalizedCode,
      );

  WebLocalSettingsEntity toEntity() => WebLocalSettingsEntity(
        enterpriseId: enterpriseId,
        concentratorPort: concentratorPort,
        navsPort: navsPort,
        defaultUrl: defaultUrl,
        enteprisePersonalizedCode: enteprisePersonalizedCode,
      );
}
