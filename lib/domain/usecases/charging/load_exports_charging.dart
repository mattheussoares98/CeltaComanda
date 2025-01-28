import '../../../data/models/models.dart';

abstract class LoadExportsCharging {
  Future<ExportChargingModel> loadExportsCharging({required String pdvNumber});
}
