import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;
  final SaveUrl saveUrl;
  final SaveUserName saveUserName;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
    required this.saveUrl,
    required this.saveUserName,
  });

  @override
  Future<CrossIdEntity?> auth(AuthenticationParams params) async {
    await saveUrl.save(url);
    await saveUserName.save(params.user);

    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteCrossIdModel.fromJson(httpResponse).toEntity();
    } /* on HttpError */ catch (error) {
      /* throw error == HttpError.unauthorized
        ? DomainError.invalidCredentials
        : */
      throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String user;
  final String password;

  RemoteAuthenticationParams({
    required this.user,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(
    AuthenticationParams params,
  ) {
    return RemoteAuthenticationParams(
      user: params.user,
      password: params.password,
    );
  }

  Map toJson() => {
        "user": user,
        "password": password,
      };
}
