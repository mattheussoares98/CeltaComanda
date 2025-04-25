import '../../../data/models/models.dart';

abstract class GetnetPay {
  Future<GetNetResponseModel?> pay(PayParamsModel params);
}
