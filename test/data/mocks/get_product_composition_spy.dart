// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class GetProductCompositionSpy extends Mock implements GetProductComposition {
  When mockGetProductCompositionCall() => when(() => this.get(
        url: any(named: "url"),
        enterpriseId: any(named: "enterpriseId"),
        internalCodeOnErp: any(named: "internalCodeOnErp"),
      ));

  void mockGetProductComposition(
          List<ProductCompositionEntity> productsCompositions) =>
      this
          .mockGetProductCompositionCall()
          .thenAnswer((_) async => productsCompositions);

  void mockGetProductCompositionError() =>
      this.mockGetProductCompositionCall().thenThrow(Exception());
}
