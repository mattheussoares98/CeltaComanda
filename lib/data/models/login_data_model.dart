import '../../domain/entities/entities.dart';

class LoginDataModel {
  final String url;
  final String userName;

  LoginDataModel({
    required this.url,
    required this.userName,
  });

  factory LoginDataModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['url', 'userName'])) {
      throw Exception();
    }
    return LoginDataModel(
      url: json['url'],
      userName: json['userName'],
    );
  }

  factory LoginDataModel.fromEntity(LoginDataEntity entity) => LoginDataModel(
        url: entity.url,
        userName: entity.userName,
      );

  LoginDataEntity toEntity() => LoginDataEntity(
        url: url,
        userName: userName,
      );

  Map<String, String> toJson() => {
        'url': url,
        'userName': userName,
      };
}
