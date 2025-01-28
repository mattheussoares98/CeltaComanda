// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadExportChargingSpy extends Mock implements LoadExportCharging {
  When _mockLoadCall() => when(() => this.load(
        pdvNumber: any(named: "pdvNumber"),
      ));

  void mockLoad(ExportChargingModel model) {
    _mockLoadCall().thenAnswer((_) async => model);
  }

  void mockLoadError() {
    _mockLoadCall().thenThrow(Exception());
  }
}
