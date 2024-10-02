// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadCommandsAvailableSpy extends Mock implements LoadSaleRequestTemp {
  When mockLoadCommandsAvailableCall() => when(() => this.load(
        url: any(named: "url"),
        enterpriseId: any(named: "enterpriseId"),
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadCommandsAvailable(
          List<SaleRequestTempEntity>? expansibleGroups) =>
      this
          .mockLoadCommandsAvailableCall()
          .thenAnswer((_) async => expansibleGroups);

  void mockLoadCommandsAvailableError() =>
      this.mockLoadCommandsAvailableCall().thenThrow(Exception());
}
