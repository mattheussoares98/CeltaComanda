import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class UserValidations
    implements ValidateUserPassword, VerifyCancelPermission {
  final HttpClient httpAdapter;

  UserValidations({required this.httpAdapter});

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
      } else if (!isValidPassword) {
        throw DomainError.invalidCredentials;
      }

      return isValidPassword;
    } catch (error) {
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
      } else if (!canCancel) {
        throw DomainError.accessDenied;
      }

      return canCancel;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
