abstract class CheckPasswordByCustomerCode {
  Future<bool> validate({required int customerCode, required String password});
}
