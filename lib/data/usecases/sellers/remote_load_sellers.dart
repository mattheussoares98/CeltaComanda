import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteLoadSellers with ErrorHandling implements LoadSellers {
  final HttpClient httpAdapter;

  RemoteLoadSellers({required this.httpAdapter});

  @override
  Future<List<SellerEntity>> load() async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final response = await httpAdapter.request(
        url:
            "${EnterpriseBuilder.entity!.concentradorUrl!}/api/APISellers/GetAll?take=100&skip=0&enterpriseId=${EnterpriseBuilder.entity!.enterpriseId!}&userId=1",
        method: "get",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      }
      response.toString();

      return response.map<SellerEntity>((element) {
        return SellerModel.fromJson(element).toEntity();
      }).toList();
    } catch (e) {
      treatError(e);
    }
  }
}
