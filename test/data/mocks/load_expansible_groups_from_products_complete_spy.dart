// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadExpansibleGroupsFromProductsCompleteSpy extends Mock
    implements LoadExpansibleGroupsFromProductsComplete {
  When mockLoadExpansibleGroupsFromProductsCompleteCall() =>
      when(() => this.load(any()));

  void mockLoadExpansibleGroupsFromProductsComplete(
          List<ExpansibleGroupFromProductCompleteEntity> expansibleGroups) =>
      this
          .mockLoadExpansibleGroupsFromProductsCompleteCall()
          .thenAnswer((_) async => expansibleGroups);

  void mockLoadExpansibleGroupsFromProductsCompleteError(DomainError error) =>
      this.mockLoadExpansibleGroupsFromProductsCompleteCall().thenThrow(error);
}
