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
    required int saleRequestId,
    required int deliveryLoteNumber,
    required IsToDelivery newStatus,
    OriginType? originType = OriginType.saleRequest,
  }) async {
    final url =
        '${settings.defaultUrl}:${settings.concentratorPort}/api/APIDeliveryControl/UpdateDeliveryStatus?originType=${originType!.value}&saleRequestId=$saleRequestId&deliveryStatus=${newStatus.value}&deliveryLoteNumber=$deliveryLoteNumber';

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
