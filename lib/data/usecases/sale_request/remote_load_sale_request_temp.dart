import '../../../main/builders/builders.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';
import '../../http/http.dart';

class RemoteLoadSaleRequestTemp
    with ErrorHandling
    implements LoadSaleRequestTemp {
  final HttpClient httpAdapter;

  RemoteLoadSaleRequestTemp({
    required this.httpAdapter,
  });

  @override
  Future<SaleRequestTempEntity> load({
    required String commandNumber,
  }) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
      final saleRequestTemp = await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/GetTemp?_enterpriseId=$enterpriseId&_personalizedCode=$commandNumber",
        method: "get",
      );
      if (saleRequestTemp == null) throw Error();

      return SaleRequestTempModel.fromJson(saleRequestTemp).toEntity();
    } catch (e) {
      treatError(e);
    }
  }
}
