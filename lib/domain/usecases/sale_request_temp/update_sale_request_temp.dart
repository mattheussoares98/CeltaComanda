import '../../entities/entities.dart';

abstract class UpdateSaleRequestTemp {
  Future<void> update({
    required String url,
    required UpdateSaleRequestTempEntity entity,
  });
}
