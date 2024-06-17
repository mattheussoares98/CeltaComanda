import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../../ui/pages/pages.dart';
import '../../cache/cache.dart';

class LocalCartInformations implements CartInformations {
  final HiveStorage hiveStorage;

  LocalCartInformations({required this.hiveStorage});

  @override
  Future<void> updateCartProducts(List<CartProductsViewModel> cartProducts) async {
    try {
      await hiveStorage.delete(CacheKeys.cartProducts.name);

      final cartProductsEncoded =
          jsonEncode(cartProducts.map((element) => element.toJson()).toList());

      await hiveStorage.put(CacheKeys.cartProducts.name, cartProductsEncoded);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<CartProductsViewModel>?> getCartProducts() async {
    try {
      final value = await hiveStorage.get(CacheKeys.cartProducts.name);
      if (value == null) {
        return null;
      } else {
        final List decoded = jsonDecode(value);
        final cartProducts = decoded
            .map((element) => CartProductsViewModel.fromJson(element))
            .toList();
        return cartProducts;
      }
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> clearCartProducts({int retryCountInErrorCase = 0}) async {
    try {
      await hiveStorage.delete(CacheKeys.cartProducts.name);
    } catch (e) {
      if (retryCountInErrorCase < 3) {
        //se der erro pra executar a primeira vez, vai tentar executar mais 3 vezes
        await clearCartProducts(retryCountInErrorCase: retryCountInErrorCase + 1);
      } else {
        throw DomainError.unexpected;
      }
    }
  }
}
