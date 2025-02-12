import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadGroupPermissionsSpy extends Mock implements LoadGroupPermissions {
  When _mockGetAllCall() => when(() => this.getAll());
  void mockGetAll(List<GroupPermissionConcentratorEntity> result) {
    this._mockGetAllCall().thenAnswer((_) async => result);
  }

  void mockGetAllError() {
    this._mockGetAllCall().thenThrow(Exception());
  }
}
