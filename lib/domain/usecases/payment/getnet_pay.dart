import '../../../data/models/models.dart';

abstract class GetnetPay {
  Future<Map<String, dynamic>?> pay(PayParamsModel params);//TODO create a model to treat the return
}
