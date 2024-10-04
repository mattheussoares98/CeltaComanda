import '../../../data/models/models.dart';

abstract class CovenantAuthorizationIsPendant {
  Future<bool> get();
  Future<void> update(AuthorizationPendingModel? model);
}
