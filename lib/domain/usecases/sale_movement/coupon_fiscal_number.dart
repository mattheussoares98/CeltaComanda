abstract class CouponFiscalNumber {
  Future<int> loadLastNumber();
  Future<void> save(int number);
}
