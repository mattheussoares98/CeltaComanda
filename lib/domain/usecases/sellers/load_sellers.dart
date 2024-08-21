import '../../entities/entities.dart';

abstract class LoadSellers {
  Future<List<SellerEntity>> load();
}
