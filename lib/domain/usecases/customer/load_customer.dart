import '../../entities/entities.dart';

abstract class LoadCustomer {
  Future<List<CustomerEntity>?> load({
    required String value,
    required int searchTypeInt,
  });
}
