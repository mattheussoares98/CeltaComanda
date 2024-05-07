import '../../../domain/entities/entities.dart';

abstract class SearchProductByCode {
  Future<ProductEntity> search({
    required String url,
    required String value,
    required String enterpriseId,
  });
}
