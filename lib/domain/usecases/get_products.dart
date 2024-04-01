import '../entities/entities.dart';

abstract class GetProducts {
  Future<List<ProductEntity>?> getProducts();
}