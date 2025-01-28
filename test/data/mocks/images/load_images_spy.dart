// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadImagesSpy extends Mock implements LoadImages {
  When _mockLoadCall() =>
      when(() => this.load(getLocalImages: any(named: "getLocalImages"),));

  void mockLoad(List<ImageModel> images) {
    _mockLoadCall().thenAnswer((_) async => images);
  }

  void mockLoadError() {
    _mockLoadCall().thenThrow(Exception());
  }
}
