import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class ConcUpdateDeliveryStatus implements UpdateDeliveryStatus {
  final HttpClient httpClient;
  ConcUpdateDeliveryStatus(this.httpClient);

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
}
