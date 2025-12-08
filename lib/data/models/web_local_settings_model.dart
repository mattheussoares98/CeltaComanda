import '../../domain/entities/entities.dart';

class WebLocalSettingsModel {
  final String? url;
  final int? enterpriseId;
  final bool? isConsiderDelivered;

  WebLocalSettingsModel({
    required this.url,
    required this.enterpriseId,
    required this.isConsiderDelivered,
  });

  factory WebLocalSettingsModel.fromJson(Map<String, dynamic> json) =>
      WebLocalSettingsModel(
        url: json['url'],
        enterpriseId: json['enterpriseId'],
        isConsiderDelivered: json['isConsiderDelivered'],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "enterpriseId": enterpriseId,
        "isConsiderDelivered": isConsiderDelivered,
      };

  factory WebLocalSettingsModel.fromEntity(WebLocalSettingsEntity entity) =>
      WebLocalSettingsModel(
        url: entity.url,
        enterpriseId: entity.enterpriseId,
        isConsiderDelivered: entity.isConsiderDelivered,
      );

  WebLocalSettingsEntity toEntity() => WebLocalSettingsEntity(
        url: url,
        enterpriseId: enterpriseId,
        isConsiderDelivered: isConsiderDelivered,
      );
}
