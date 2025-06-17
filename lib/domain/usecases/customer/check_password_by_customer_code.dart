abstract class CheckPasswordByCustomerCode {
  Future<dynamic> validate({
    required int customerCode,
    required String password,
  });
}
