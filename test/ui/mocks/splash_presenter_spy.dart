// ignore_for_file: unnecessary_this

import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock
    implements SplashPresenter /* LoadCrossId */ {
  SplashPresenterSpy() {
    when(() => this
            .checkPageToGo(durationInSeconds: any(named: 'durationInSeconds')))
        .thenAnswer((any) async => any);
  }

  // void mockLoadAccount(CrossIdEntity? crossIdEntity) {
  //   when(() => this.load()).thenAnswer((_) async => crossIdEntity);
  // }
}
