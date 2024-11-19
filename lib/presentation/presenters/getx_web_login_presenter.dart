import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebLoginPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebLoginPresenter {
  final NavigateTo navigateTo;

  GetxWebLoginPresenter({
    required this.navigateTo,
  });

  @override
  Future<void> doLogin({
    required String email,
    required String password,
  }) async {}
}
