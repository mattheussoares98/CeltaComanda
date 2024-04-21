import '../../domain/entities/entities.dart';

class EnterpriseValidationModel {
  final String url;
  final String? enterpriseName;
  final int? enterpriseId;

  EnterpriseValidationModel({
    required this.url,
    this.enterpriseName,
    this.enterpriseId,
  });

  factory EnterpriseValidationModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['url', 'enterpriseId', 'enterpriseName'])) {
      throw Exception();
    }
    return EnterpriseValidationModel(
      url: json['url'],
      enterpriseName: json["enterpriseName"],
      enterpriseId: json["enterpriseId"],
    );
  }

  factory EnterpriseValidationModel.fromEntity(
          EnterpriseEntity entity) =>
      EnterpriseValidationModel(
        url: entity.url!,
        enterpriseName: entity.enterpriseName,
        enterpriseId: entity.enterpriseId!,
      );

  EnterpriseEntity toEntity() => EnterpriseEntity(
        url: url.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        enterpriseName:
            enterpriseName!.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        enterpriseId: enterpriseId,
      );

  Map<String, dynamic> toJson() => {
        'url': url.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        'enterpriseName':
            enterpriseName?.toLowerCase().replaceAll(RegExp(r'\s+'), '') ?? "",
        'enterpriseId': enterpriseId,
      };
}
