import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxPrintedProductsPresenter extends GetxController
    with LoadingManager
    implements PrintedProductsPresenter {
  final NavigateTo navigateTo;

  GetxPrintedProductsPresenter({
    required this.navigateTo,
  });

  @override
  Stream<UIError?> get enterpriseErrorStream => throw UnimplementedError();

  @override
  Stream<bool> get isFormValidStream => throw UnimplementedError();

  @override
  Future<void> loadRemoteData() {
    throw UnimplementedError();
  }

  @override
  Stream<UIError?> get mainErrorStream => throw UnimplementedError();
}
