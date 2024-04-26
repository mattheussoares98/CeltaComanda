import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteValidateUserPassword implements ValidateUserPassword {
  final HttpClient httpAdapter;

  RemoteValidateUserPassword({required this.httpAdapter});

  @override
  Future<bool> validateUser({
    required String url,
    required int personalizedCode,
    required String password,
  }) async {
    try {
      final canCancel = await httpAdapter.request(
        url:
            "$url/api/APIUsers/ValidPassword?personalizedCode=$personalizedCode&password=$password",
        method: "get",
      );
      if (canCancel == null) {
        throw Error();
      } else if(!canCancel){
        throw DomainError.accessDenied;
      }

      return canCancel;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
