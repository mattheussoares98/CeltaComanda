import '../../entities/entities.dart';

abstract class LoadPrintedProducts {
  Future<PrintedEntity?> load({
    required int commandNumber,
    int? enterpriseId,
    String? url,
  });
}
