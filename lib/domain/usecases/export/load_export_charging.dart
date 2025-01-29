import '../../entities/entities.dart';

abstract class LoadExportCharging {
  Future<List<ExportChargingEntity>> load({required String pdvNumber});
}
