abstract class PaidInformations {
  Future<bool> getAlreadyPaid();
  Future<void> updateAlreadyPaid(bool newValue);
}
