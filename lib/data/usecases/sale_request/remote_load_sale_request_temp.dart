import '../../../main/builders/builders.dart';
import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadSaleRequestTemp implements LoadSaleRequestTemp {
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
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
