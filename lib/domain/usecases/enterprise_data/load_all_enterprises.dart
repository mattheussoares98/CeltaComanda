import 'package:clean_celta_mobile/domain/entities/entities.dart';

abstract class LoadAllEnterprises {
  Future<List<EnterpriseEntity>?> load();
}
