import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteConcDeliveryControl implements ConcDeliveryControl {
  final HttpClient httpClient;
  RemoteConcDeliveryControl(this.httpClient);

  @override
  Future<void> update({
    required WebLocalSettingsEntity settings,
    required DeliveryControlEntity deliveryControl,
    required int? deliveryLoteNumber,
    required IsToDelivery newStatus,
  }) async {
    final url =
        '${settings.defaultUrl}:${settings.concentratorPort}/api/APIDeliveryControl/UpdateDeliveryStatus?originType=${deliveryControl.OriginType.value}&saleRequestId=${deliveryControl.Id}&deliveryStatus=${newStatus.value}&deliveryLoteNumber=$deliveryLoteNumber';

    await httpClient.request(
      url: url,
      method: "get",
      headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
    );
  }

  @override
  Future<List<DeliveryControlEntity>> load(
    WebLocalSettingsEntity settings,
  ) async {
    final response = await httpClient.request(
      url:
          '${settings.defaultUrl}:${settings.concentratorPort}/api/APIDeliveryControl/GetSaleRequestDeliveryStatus?enteprisePersonalizedCode=${settings.enteprisePersonalizedCode}',
      method: "get",
      headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
    );

    if (response == null) {
      return [];
    }

    return (response as List)
        .map((e) => DeliveryControlModel.fromJson(e).toEntity())
        .toList();
  }

  @override
  Future<List<DeliveryControlEntity>> loadWithProducts(
    WebLocalSettingsEntity settings,
  ) async {
    final response = await httpClient.request(
      url:
          '${settings.defaultUrl}:${settings.concentratorPort}/api/APIDeliveryControl/GetDeliveryStatusWithProducts?enteprisePersonalizedCode=${settings.enteprisePersonalizedCode}',
      method: "get",
      headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
    );

    if (response == null) {
      return [];
    }

    return (response as List)
        .map((e) => DeliveryControlModel.fromJson(e).toEntity())
        .toList();
  }
}
