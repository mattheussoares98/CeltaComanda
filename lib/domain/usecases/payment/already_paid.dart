abstract class AlreadyPaid {
  Future<bool> verify();
  Future<void> update(bool newValue);
}
