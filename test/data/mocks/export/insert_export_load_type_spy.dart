import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class InsertExportLoadTypeSpy extends Mock implements InsertExportLoadType {
  InsertExportLoadTypeSpy() {
    this.mockInsert();
  }
  When _mockInsertCall() => when(() => this.insert(any()));

  void mockInsert() {
    this._mockInsertCall().thenAnswer((any) async => any);
  }

  void mockLoadError() {
    this._mockInsertCall().thenThrow(Exception());
  }
}
