import '../../domain/entities/entities.dart';

class SettingsModel {
  final String? url;
  final int? enterpriseId;
  final bool? isConsiderDelivered;

  SettingsModel({
    required this.url,
    required this.enterpriseId,
    required this.isConsiderDelivered,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        url: json['url'],
        enterpriseId: json['enterpriseId'],
        isConsiderDelivered: json['isConsiderDelivered'],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "enterpriseId": enterpriseId,
        "isConsiderDelivered": isConsiderDelivered,
      };

  factory SettingsModel.fromEntity(SettingsEntity entity) => SettingsModel(
        url: entity.url,
        enterpriseId: entity.enterpriseId,
        isConsiderDelivered: entity.isConsiderDelivered,
      );

  SettingsEntity toEntity() => SettingsEntity(
        url: url,
        enterpriseId: enterpriseId,
        isConsiderDelivered: isConsiderDelivered,
      );
}
