import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../database/database.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class ConcentratorLoadImages implements LoadImages {
  final HiveStorage hiveStorage;
  final HttpClient httpClient;

  ConcentratorLoadImages({
    required this.hiveStorage,
    required this.httpClient,
  });

  @override
  Future<List<ImageModel>> load(List<String> pluOrEan) async {
    try {
      final concentratorUrl = EnterpriseBuilder.entity?.concentradorUrl;
      final response = await httpClient.request(
          url: "$concentratorUrl/api/APIImport/GetImages", method: "get");

      List<String> plusAndEansThatContainsImages = [];
    } catch (e) {
      throw DomainError.unexpected;
    }
    return [];
  }
}
