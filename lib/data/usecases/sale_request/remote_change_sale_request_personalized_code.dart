import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteChangeSaleRequestPersonalizedCode
    implements ChangeSaleRequestPersonalizedCode {
  final HttpClient httpAdapter;

  RemoteChangeSaleRequestPersonalizedCode({required this.httpAdapter});

  @override
  Future<void> change({
    required String oldPersonalizedCode,
    required String newPersonalizedCode,
  }) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final enterpriseId =
          EnterpriseBuilder.entity!.enterpriseId;
      final oldCode = oldPersonalizedCode.padLeft(3, "0");
      final newCode = newPersonalizedCode.padLeft(3, "0");

      await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/ChangeSaleRequestPersonalizedCode?enterpriseId=$enterpriseId&oldPersonalizedCode=$oldCode&newPersonalizedCode=$newCode",
        method: "post",
      );
    } catch (error) {
      switch (error) {
        case HttpError.badRequest:
          throw DomainError.newCommandMustBeEmpty;
        case HttpError.notFound:
          throw DomainError.oldCommandIsEmpty;
        default:
          throw DomainError.unexpected;
      }
    }
  }
}
