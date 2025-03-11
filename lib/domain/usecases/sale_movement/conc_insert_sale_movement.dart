import '../../entities/entities.dart';

abstract class ConcInsertSaleMovement {
  Future<int> insert({
    required int pdvId,
    required String pdvNumber,
    required int? covenantCode,
    required int? customerCode,
    required String? cpfCnpj,
    required int? incrementType,
    required double? incrementValue,
    required double totalLiquid,
    required List<SaleMovementConcentratorFinalizationEntity> finalizations,
    required List<SaleMovementProductConcentratorEntity> products,
    required String? xmlToGenerateFiscal,
  });
}
