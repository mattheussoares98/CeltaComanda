abstract class UpdateProductComment {
  Future<void> update({
    required String url,
    required int saleRequestProductTempId,
    required String comments,
  });
}
