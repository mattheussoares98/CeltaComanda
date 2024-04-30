abstract class UpdateProductQuantity {
  Future<void> add({
    required String url,
    required int saleRequestProductTempId,
  });

  Future<void> subtract({
    required String url,
    required int saleRequestProductTempId,
  });
}
