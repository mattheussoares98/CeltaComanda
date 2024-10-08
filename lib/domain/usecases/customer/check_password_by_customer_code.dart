abstract class CheckPasswordByCustomerCode {
  Future<bool> isValid({required int customerCode, required String password});
}
