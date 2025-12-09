import '../../domain/entities/entities.dart';

class WebLocalSettingsModel {
  final String? url;
  final int? enterpriseId;
  final String? enteprisePersonalizedCode;
  final bool? isConsiderDelivered;

  WebLocalSettingsModel({
    required this.url,
    required this.enterpriseId,
    required this.enteprisePersonalizedCode,
    required this.isConsiderDelivered,
  });

  factory WebLocalSettingsModel.fromJson(Map<String, dynamic> json) =>
      WebLocalSettingsModel(
        url: json['url'],
        enterpriseId: json['enterpriseId'],
        enteprisePersonalizedCode: json['enteprisePersonalizedCode'],
        isConsiderDelivered: json['isConsiderDelivered'],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "enterpriseId": enterpriseId,
        "enteprisePersonalizedCode": enteprisePersonalizedCode,
        "isConsiderDelivered": isConsiderDelivered,
      };

  factory WebLocalSettingsModel.fromEntity(WebLocalSettingsEntity entity) =>
      WebLocalSettingsModel(
        url: entity.url,
        enterpriseId: entity.enterpriseId,
        enteprisePersonalizedCode: entity.enteprisePersonalizedCode,
        isConsiderDelivered: entity.isConsiderDelivered,
      );

  WebLocalSettingsEntity toEntity() => WebLocalSettingsEntity(
        url: url,
        enterpriseId: enterpriseId,
        enteprisePersonalizedCode: enteprisePersonalizedCode,
        isConsiderDelivered: isConsiderDelivered,
      );
}
