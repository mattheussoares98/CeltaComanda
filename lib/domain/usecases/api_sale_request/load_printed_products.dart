import '../../entities/entities.dart';

abstract class LoadPrintedProducts {
  Future<PrintedEntity?> load({
    required String url,
    required int enterpriseId,
    required int commandNumber,
  });
}
