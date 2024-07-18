// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadExpansibleGroupsFromProductsCompleteSpy extends Mock
    implements LoadExpansibleGroupsFromProductsComplete {
  When mockCall() => when(() => this.load(any()));

  void mockLoad(
          List<ExpansibleGroupFromProductCompleteEntity>
              expansibleGroupFromProductComplete) =>
      this
          .mockCall()
          .thenAnswer((_) async => expansibleGroupFromProductComplete);

  void mockError() => this.mockCall().thenThrow(DomainError.unexpected);
}
