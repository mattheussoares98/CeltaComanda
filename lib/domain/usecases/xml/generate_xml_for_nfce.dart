import '../../../data/models/models.dart';
import '../../entities/entities.dart';

abstract class GenerateXmlForNfce {
  Future<String> generate({
    required List<PrintedProductsEntity> products,
    required List<ConcentratorFinalizationModel> finalizations,
    required CustomerEntity? customer,
    required int? cpfCnpj,
    required int? pdvNumber,
    required double? incrementValue,
    required int couponFiscalNumber,
  });
}
