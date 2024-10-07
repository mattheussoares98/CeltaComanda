import '../../../data/models/models.dart';

abstract class CovenantAuthorizationIsPendant {
  Future<AuthorizationPendingModel?> get();
  Future<void> update(AuthorizationPendingModel? model);
}
