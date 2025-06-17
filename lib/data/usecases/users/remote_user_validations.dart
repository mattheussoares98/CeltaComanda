import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteUserValidations with ErrorHandling implements UserValidations {
  final HttpClient httpAdapter;

  RemoteUserValidations({required this.httpAdapter});

  @override
  Future<bool> isValidPassword({
    required String url,
    required int personalizedCode,
    required String password,
  }) async {
    try {
      final isValidPassword = await httpAdapter.request(
        url:
            "$url/api/APIUsers/ValidPassword?personalizedCode=$personalizedCode&password=$password",
        method: "get",
      );
      if (isValidPassword == null) {
        throw Error();
      }

      return isValidPassword;
    } catch (error) {
      if (error == HttpError.serverError) {
        throw DomainError.invalidCredentialsOrAccessDenied;
      }
      throw DomainError.unexpected;
    }
  }

  @override
  Future<bool> canCancel(
      {required int personalizedCode, required String url}) async {
    try {
      final canCancel = await httpAdapter.request(
        url:
            "$url/api/APIUsers/UserPermissionCancel?personalizedCode=$personalizedCode",
        method: "get",
      );
      if (canCancel == null) {
        throw Error();
      }

      return canCancel;
    } catch (e) {
      treatError(e);
    }
  }
}
