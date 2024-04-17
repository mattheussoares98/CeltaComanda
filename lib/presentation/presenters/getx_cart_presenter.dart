import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxCartPresenter extends GetxController
    with LoadingManager
    implements CartPresenter {
  final NavigateTo navigateTo;
  GetxCartPresenter({
    required this.navigateTo,
  });

  final _cartItems = Rx<List<CartViewModel>>([]);

  @override
  Stream<List<CartViewModel>> get cartProducts => _cartItems.stream;
}
