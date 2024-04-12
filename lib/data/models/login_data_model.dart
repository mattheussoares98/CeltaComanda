import '../../domain/entities/entities.dart';

class LoginDataModel {
  final String url;
  final String userName;
  final String? enterpriseName;

  LoginDataModel({
    required this.url,
    required this.userName,
    this.enterpriseName,
  });

  factory LoginDataModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['url', 'userName'])) {
      throw Exception();
    }
    return LoginDataModel(
      url: json['url'],
      userName: json['userName'],
      enterpriseName: json["enterpriseName"],
    );
  }

  factory LoginDataModel.fromEntity(LoginDataEntity entity) => LoginDataModel(
        url: entity.url,
        userName: entity.userName,
        enterpriseName: entity.enterpriseName,
      );

  LoginDataEntity toEntity() => LoginDataEntity(
        url: url.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        userName: userName,
        enterpriseName: enterpriseName?.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
      );

  Map<String, String> toJson() => {
        'url': url.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        'userName': userName,
        'enterpriseName': enterpriseName?.toLowerCase().replaceAll(RegExp(r'\s+'), '') ?? "",
      };
}
