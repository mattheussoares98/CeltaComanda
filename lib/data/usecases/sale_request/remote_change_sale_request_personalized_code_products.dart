import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteChangeSaleRequestPersonalizedCodeProducts
    implements ChangeSaleRequestPersonalizedCodeProducts {
  final HttpClient httpAdapter;

  RemoteChangeSaleRequestPersonalizedCodeProducts({required this.httpAdapter});

  @override
  Future<void> change({
    required String oldPersonalizedCode,
    required String newPersonalizedCode,
    required List<int> saleRequestProductsIds,
  }) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final enterpriseId =
          EnterpriseBuilder.entity!.enterpriseId;
      final oldCode = oldPersonalizedCode.padLeft(3, "0");
      final newCode = newPersonalizedCode.padLeft(3, "0");

      await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/ChangeSaleRequestPersonalizedCodeProducts?enterpriseId=$enterpriseId&oldPersonalizedCode=$oldCode&newPersonalizedCode=$newCode",
        method: "post",
        body: saleRequestProductsIds,
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
