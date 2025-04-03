import '../../../ui/pages/pages.dart';
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
    required int couponFiscalNumber,
    required List<ConcentratorFinalizationEntity> finalizations,
    required List<PrintedProductsViewModel> products,
    required String? xmlToGenerateFiscal,
    required int commandNumber,
  });
}
