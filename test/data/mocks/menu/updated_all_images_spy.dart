// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdatedAllImagesSpy extends Mock implements UpdatedAllImages {
  UpdatedAllImagesSpy() {
    _updateLastDateCall().thenAnswer((any) async => any);
  }

  When _updateLastDateCall() => when(() => this.updateLastDate(any()));

  void mockUpdateLastDateError() {
    _updateLastDateCall().thenThrow(DomainError.unexpected);
  }

  When _getLastDateCall() => when(() => this.getLastDate());
  void mockGetLastDate(DateTime date) =>
      _getLastDateCall().thenAnswer((any) async => date);
  void getLastDataError() {
    _getLastDateCall().thenThrow(DomainError.unexpected);
  }
}
