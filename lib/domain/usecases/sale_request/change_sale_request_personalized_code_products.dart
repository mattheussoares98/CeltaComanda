abstract class ChangeSaleRequestPersonalizedCodeProducts {
  Future<void> change({
    required String oldPersonalizedCode,
    required String newPersonalizedCode,
    required List<int> saleRequestProductsIds,
  });
}
