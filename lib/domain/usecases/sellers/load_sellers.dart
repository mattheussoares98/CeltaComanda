import '../../entities/entities.dart';

abstract class LoadSellers {
  Future<SellerEntity> load();
}
