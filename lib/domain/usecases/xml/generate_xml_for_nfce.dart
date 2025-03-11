import '../../../data/models/models.dart';
import '../../entities/entities.dart';

abstract class GenerateXmlForNfce {
  Future<String> generate({
    required List<PrintedProductsEntity> products,
    required List<SaleMovementConcentratorFinalizationModel> finalizations,
    required CustomerEntity? customer,
    required int? cpf,
    required int? cnpj,
    required int? pdvNumber,
    required double? incrementValue,
  });
}
