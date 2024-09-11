// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class GetProductCompositionSpy extends Mock implements GetProductComposition {
  When mockGetFathersCall() => when(() => this.getFathers(
        internalCodeOnErp: any(named: "internalCodeOnErp"),
      ));

  void mockGetFathers(List<ProductCompositionEntity> productsCompositions) =>
      this.mockGetFathersCall().thenAnswer((_) async => productsCompositions);

  void mockGetFathersError() =>
      this.mockGetFathersCall().thenThrow(Exception());

  When mockGetChildsOfFatherCall() => when(() => this.getChildsOfFather(
        internalCodeOnErp: any(named: "internalCodeOnErp"),
        fathers: any(named: "fathers"),
      ));
  void mockGetChildsOfFather(List<ProductCompositionEntity> childs) =>
      this.mockGetChildsOfFatherCall().thenAnswer((_) async => childs);
  void mockGetChildsOfFatherError() =>
      this.mockGetFathersCall().thenThrow(Exception());
}
