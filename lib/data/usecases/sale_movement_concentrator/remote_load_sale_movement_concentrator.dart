import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadSaleMovementConcentrator
    implements LoadSaleMovementConcentrator {
  final HttpClient httpAdapter;

  RemoteLoadSaleMovementConcentrator({required this.httpAdapter});

  @override
  Future<List<SaleMovementConcentratorEntity>> load({
    required String date,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url =
          "${EnterpriseBuilder.entity!.concentradorUrl}/api/APISaleMovement/Search?enterpriseId=${EnterpriseBuilder.entity!.enterpriseId}&date=2024-12-19&onlyCancelled=false";
      final response = await httpAdapter.request(
        url: url,
        method: "put",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      }

      // return (json.decode(response) as List).map((e) => ).toList();
      return []; //TODO create SaleMovementConcentratorModel to convert to entity
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
