// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:mocktail/mocktail.dart';

class LocalPrintRequestSpy extends Mock implements LocalPrintRequest {
  LocalPrintRequestSpy() {
    mockAdd();
    mockClear();
  }

  When mockGetMergedPrintedCall() => when(() => this.getLocalPrintedEntity());
  void mockGetMergedPrinted(PrintRequestEntity? entity) =>
      this.mockGetMergedPrintedCall().thenAnswer((_) async => entity);
  void mockGetMergedPrintedError() =>
      this.mockGetMergedPrintedCall().thenThrow(Exception());

  When mockAddCall() => when(() => this.add(any()));
  void mockAdd() => this.mockAddCall().thenAnswer((any) async => any);
  void mockAddError() => this.mockAddCall().thenThrow(Exception());

  When mockClearCall() => when(() => this.clear());
  void mockClear() => this.mockClearCall().thenAnswer((any) async => any);
  void mockClearError() => this.mockClearCall().thenThrow(Exception());
}
