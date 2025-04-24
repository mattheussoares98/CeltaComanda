import '../../../data/models/models.dart';

abstract class RedePay {
  Future<void> pay(PayParamsModel params);
}
