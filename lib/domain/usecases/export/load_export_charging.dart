import '../../../data/models/models.dart';

abstract class LoadExportCharging {
  Future<ExportChargingModel> loadExportsCharging({required String pdvNumber});
}
