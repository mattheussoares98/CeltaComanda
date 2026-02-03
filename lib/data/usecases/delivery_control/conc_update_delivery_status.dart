import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class ConcUpdateDeliveryStatus implements UpdateDeliveryStatus {
  final HttpClient httpClient;
  ConcUpdateDeliveryStatus(this.httpClient);

  @override
  Future<void> update({
    required WebLocalSettingsEntity settings,
    required int id,
    required IsToDelivery newStatus,
    OriginType? originType = OriginType.saleRequest,
  }) async {
    final url =
        '${settings.concentratorUrl}/api/APIDeliveryControl/UpdateDeliveryStatus?originType=${originType!.value}&id=$id&deliveryStatus=${newStatus.value}';

    await httpClient.request(
      url: url,
      method: "get",
      headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
    );
  }
}
