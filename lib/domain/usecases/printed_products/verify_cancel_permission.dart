abstract class VerifyCancelPermission {
  Future<bool> canCancel({
    required int personalizedCode,
    required String url,
  });
}
