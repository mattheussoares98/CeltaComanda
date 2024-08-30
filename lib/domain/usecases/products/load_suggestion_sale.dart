import '../../entities/entities.dart';

abstract class LoadSuggestionSale {
  Future<List<SuggestionSaleEntity>?> load();
}
