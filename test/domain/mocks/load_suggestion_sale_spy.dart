// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadSuggestionSaleSpy extends Mock implements LoadSuggestionSale {
  When mockLoadCall() => when(() => this.load());
  void mockLoad(List<SuggestionSaleEntity> suggestions) =>
      this.mockLoadCall().thenAnswer((_) async => suggestions);

  void mockLoadError() => this.mockLoadCall().thenThrow(DomainError.unexpected);
}
