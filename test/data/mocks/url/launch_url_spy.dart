// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LaunchUrlSpy extends Mock implements LaunchUrl {
  LaunchUrlSpy() {
    this.mockLaunch();
  }

  When _mockLaunchUrlCall() => when(
        () => this.launch(any()),
      );

  void mockLaunch() {
    this._mockLaunchUrlCall().thenAnswer((any) async => any);
  }

  void mockLaunchError() {
    this._mockLaunchUrlCall().thenThrow(Exception());
  }
}
