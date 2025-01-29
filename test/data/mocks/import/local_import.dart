// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LastImportSpy extends Mock implements LastImport {
  LastImportSpy() {
    this.mockLoad(null);
    this.mockSave();
  }

  When _mockLoadCall() => when(() => this.load());
  void mockLoad(LastImportEntity? entity) {
    this._mockLoadCall().thenAnswer((_) async => entity);
  }

  void mockLoadError() {
    this._mockLoadCall().thenThrow(Exception());
  }

  When _mockSaveCall() => when(() => this.save(any()));
  void mockSave() {
    this._mockSaveCall().thenAnswer((any) async => any);
  }

  void mockSaveError() {
    this._mockSaveCall().thenThrow(Exception());
  }
}
