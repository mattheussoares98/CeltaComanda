import '../../../data/models/models.dart';

abstract class CieloPay {
  Future<Map<String, dynamic>?> pay(PayParamsModel params);
}
