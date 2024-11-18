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
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;
      final enterpriseId =
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId;

      await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/ChangeSaleRequestPersonalizedCode?enterpriseId=$enterpriseId&oldPersonalizedCode=$oldPersonalizedCode&newPersonalizedCode=$newPersonalizedCode",
        method: "post",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
