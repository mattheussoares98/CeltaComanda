import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class ConcLoadDeliveryControl implements LoadDeliveryControl {
  final HttpClient httpClient;
  ConcLoadDeliveryControl(this.httpClient);

  @override
  Future<List<DeliveryControlEntity>> load(
    WebLocalSettingsEntity settings,
  ) async {
    final response = await httpClient.request(
      url:
          '${settings.url}/api/APIDeliveryControl/GetSaleRequestDeliveryStatus?enteprisePersonalizedCode=${settings.enteprisePersonalizedCode}',
      method: "get",
      headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
    );

    return (response as List)
        .map((e) => DeliveryControlModel.fromJson(e).toEntity())
        .toList();
  }
}
