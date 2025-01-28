import '../../../data/models/models.dart';

abstract class LoadExportCharging {
  Future<ExportChargingModel> load({required String pdvNumber});
}
