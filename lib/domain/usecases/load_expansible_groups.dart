import '../entities/entities.dart';

abstract class LoadExpansibleGroups {
  Future<List<ProductEntity>?> getExpansibleGroups();
}