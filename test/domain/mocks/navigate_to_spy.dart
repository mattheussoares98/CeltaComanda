// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class NavigateToSpy extends Mock implements NavigateTo {
  NavigateToSpy() {
    mockNavigate();
  }
  When mockNavigateCall() => when(() => this.navigate(
        pageRoute: any(named: "pageRoute"),
        arguments: any(named: "arguments"),
        clear: any(named: "clear"),
      ));

  void mockNavigate() {
    mockNavigateCall().thenAnswer((_) async => _);
  }
}
