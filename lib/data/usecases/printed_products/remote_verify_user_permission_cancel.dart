import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteVerifyUserPermissionCancel implements VerifyUserPermissionCancel {
  final HttpClient httpAdapter;
  RemoteVerifyUserPermissionCancel({
    required this.httpAdapter,
  });

  @override
  Future<bool> verify({
    required int personalizedCode,
    required String url,
  }) async {
    try {
      final canCancel = await httpAdapter.request(
        url:
            "$url/api/APIUsers/UserPermissionCancel?personalizedCode=$personalizedCode",
        method: "get",
      );
      if (canCancel == null) throw Error();

      return canCancel;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
