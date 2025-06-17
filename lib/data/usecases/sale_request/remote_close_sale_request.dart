import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteCloseSaleRequest with ErrorHandling implements CloseSaleRequest {
  final HttpClient httpAdapter;

  RemoteCloseSaleRequest({required this.httpAdapter});

  @override
  Future<void> close(String personalizedCode) async {
    try {
      final url = EnterpriseBuilder.entity!.url;

      await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/CloseSaleRequest?_personalizedCode=$personalizedCode",
        method: "post",
      );
    } catch (e) {
      treatError(e);
    }
  }
}
