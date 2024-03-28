import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<CrossIdEntity?> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteCrossIdModel.fromJson(httpResponse).toEntity();
    } /* on HttpError */ catch (error) {
      /* throw error == HttpError.unauthorized
        ? DomainError.invalidCredentials
        : */
      DomainError.unexpected;
    }
    return null;
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;
  final String urlCcs;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
    required this.urlCcs,
  });

  factory RemoteAuthenticationParams.fromDomain(
    AuthenticationParams params,
  ) {
    return RemoteAuthenticationParams(
      email: params.user,
      password: params.password,
      urlCcs: params.urlCcs,
    );
  }

  Map toJson() => {
        R.string.user: email,
        R.string.password: password,
        R.string.urlCcs: urlCcs,
      };
}
