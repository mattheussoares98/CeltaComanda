import '../../domain/entities/entities.dart';

class LoginDataModel {
  final String url;
  final String userName;
  final String? enterpriseName;
  final int? enterpriseId;

  LoginDataModel({
    required this.url,
    required this.userName,
    this.enterpriseName,
    this.enterpriseId,
  });

  factory LoginDataModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['url', 'userName', 'enterpriseId'])) {
      throw Exception();
    }
    return LoginDataModel(
      url: json['url'],
      userName: json['userName'],
      enterpriseName: json["enterpriseName"],
      enterpriseId: json["enterpriseId"],
    );
  }

  factory LoginDataModel.fromEntity(LoginDataEntity entity) => LoginDataModel(
        url: entity.url,
        userName: entity.userName,
        enterpriseName: entity.enterpriseName,
        enterpriseId: entity.enterpriseId,
      );

  LoginDataEntity toEntity() => LoginDataEntity(
        url: url.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        userName: userName,
        enterpriseName:
            enterpriseName?.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        enterpriseId: enterpriseId,
      );

  Map<String, dynamic> toJson() => {
        'url': url.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        'userName': userName,
        'enterpriseName':
            enterpriseName?.toLowerCase().replaceAll(RegExp(r'\s+'), '') ?? "",
        'enterpriseId': enterpriseId,
      };
}
