import '../../../infra/helpers/helpers.dart';

abstract class SendSaleMovementAsNfce {
  Future<SoapResponse> send(String xml);
}
