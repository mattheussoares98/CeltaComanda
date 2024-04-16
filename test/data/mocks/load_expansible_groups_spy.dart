// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadExpansibleGroupsSpy extends Mock implements LoadExpansibleGroups {
  When mockLoadExpansibleGroupsCall() => when(() => this.load());

  void mockLoadExpansibleGroups(List<ExpansibleGroupEntity>? expansibleGroups) =>
      this.mockLoadExpansibleGroupsCall().thenAnswer((_) async => expansibleGroups);

  void mockLoadExpansibleGroupsError() =>
      this.mockLoadExpansibleGroupsCall().thenThrow(Exception());
}
