// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadExportChargingSpy extends Mock implements LoadExportCharging {
  When _mockLoadCall() => when(() => this.load(
        pdvNumber: any(named: "pdvNumber"),
      ));

  void mockLoad(List<ExportChargingEntity> entitys) {
    this._mockLoadCall().thenAnswer((_) async => entitys);
  }

  void mockLoadError() {
    this._mockLoadCall().thenThrow(Exception());
  }
}
