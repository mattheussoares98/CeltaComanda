// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadSellersSpy extends Mock implements LoadSellers {
  When mocLoadSellersCall() => when(() => this.load());

  void mockLoadSellers(List<SellerEntity> entitys) {
    this.mocLoadSellersCall().thenAnswer((_) async => entitys);
  }

  void mockLoadSellersError() {
    this.mocLoadSellersCall().thenThrow(Exception());
  }
}
