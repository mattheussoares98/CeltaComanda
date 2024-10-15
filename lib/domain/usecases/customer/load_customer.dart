import '../../../infra/helpers/helperts.dart';

abstract class LoadCustomer {
  Future<SoapResponse> load({
    required String value,
    required int searchTypeInt,
  });
}
