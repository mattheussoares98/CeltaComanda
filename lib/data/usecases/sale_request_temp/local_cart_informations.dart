import 'package:clean_celta_mobile/domain/entities/cart_product_entity.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalCartInformations implements CartInformations {
  final HiveStorage hiveStorage;

  LocalCartInformations({required this.hiveStorage});

  @override
  Future<void> update(List<CartProductEntity>? cartProducts) async {
    try {
      await hiveStorage.delete(CacheKeys.cartProducts.name);
      await hiveStorage.put(CacheKeys.cartProducts.name, cartProducts);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<CartProductEntity>?> get() async {
    try {
      return await hiveStorage.get(CacheKeys.cartProducts.name);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
