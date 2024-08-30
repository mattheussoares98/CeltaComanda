import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/products/products.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSuggestionSale implements LoadSuggestionSale {
  final HttpClient httpAdapter;

  RemoteLoadSuggestionSale({
    required this.httpAdapter,
  });

  @override
  Future<List<SuggestionSaleEntity>> load() async {
    try {
      String url =
          "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/APIProduct/GetAllProductForSuggestionSale";
      final response = await httpAdapter.request(url: url, method: "get");
      if (response == null) throw Error();

      return response.map<SuggestionSaleEntity>((element) {
        return SuggestionSaleModel.fromJson(element).toEntity();
      }).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
