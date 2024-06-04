import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../../ui/pages/pages.dart';
import '../../cache/cache.dart';

class LocalCartInformations implements CartInformations {
  final HiveStorage hiveStorage;

  LocalCartInformations({required this.hiveStorage});

  @override
  Future<void> update(List<CartProductsViewModel>? cartProducts) async {
    try {
      await hiveStorage.delete(CacheKeys.cartProducts.name);
      await hiveStorage.put(CacheKeys.cartProducts.name, cartProducts);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<CartProductsViewModel>?> get() async {
    try {
      return await hiveStorage.get(CacheKeys.cartProducts.name);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
