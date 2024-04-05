import '../../domain/entities/entities.dart';

class LocalLoginDataModel {
  final String url;
  final String userName;

  LocalLoginDataModel({
    required this.url,
    required this.userName,
  });

  factory LocalLoginDataModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['url', 'userName'])) {
      throw Exception();
    }
    return LocalLoginDataModel(
      url: json['url'],
      userName: json['userName'],
    );
  }

  factory LocalLoginDataModel.fromEntity(LoginDataEntity entity) =>
      LocalLoginDataModel(
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
