// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadPrintedProductsSpy extends Mock implements LoadPrintedProducts {
  LoadPrintedProductsSpy() {
    mockLoadPrintedEntity(null);
  }
  When mockLoadPrintedProductsCall() => when(() => this.load(
        commandNumber: any(named: "commandNumber"),
      ));

  void mockLoadPrintedEntity(PrintedEntity? entity) {
    this.mockLoadPrintedProductsCall().thenAnswer((_) async => entity);
  }

  void mockError(DomainError error) {
    this.mockLoadPrintedProductsCall().thenThrow(error);
  }
}
