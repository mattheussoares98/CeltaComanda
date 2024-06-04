import '../../entities/entities.dart';

abstract class CartInformations {
  Future<void> update(List<CartProductEntity>? cartProducts);
  Future<List<CartProductEntity>?> get();
}
