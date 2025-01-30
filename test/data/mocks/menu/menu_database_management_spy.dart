// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class MenuDatabaseManagementSpy extends Mock implements MenuDatabaseManagement {
  MenuDatabaseManagementSpy() {
    _mockSaveCall().thenAnswer((any) async => any);
  }

  void mockSaveError() {
    _mockSaveCall().thenThrow(DomainError.unexpected);
  }

  When _mockSaveCall() => when(() => this.save(any()));

  void mockLoadError() {
    _mockLoadCall().thenThrow(DomainError.unexpected);
  }

  When _mockLoadCall() => when(() => this.load());
  void mockLoad(
      List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> menu) {
    _mockLoadCall().thenAnswer((_) async => menu);
  }
}
