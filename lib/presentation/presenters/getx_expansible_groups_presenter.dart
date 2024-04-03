import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/expansible_groups/expansible_groups.dart';
import '../mixins/mixins.dart';

class GetxExpansibleGroupsPresenter extends GetxController
    with LoadingManager, NavigationManager
    implements ExpansibleGroupsPresenter {
  GetxExpansibleGroupsPresenter({required this.loadProducts});

  late final LoadExpansibleGroups loadProducts;
  final _expansibleGroups = Rx<List<ExpansibleGroupsViewModel>>([]);

  @override
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream =>
      _expansibleGroups.stream;

  @override
  Future<void> loadExpansibleGroups() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = true;
      await Future.delayed(const Duration(seconds: 3));
      _expansibleGroups.subject.add([
        const ExpansibleGroupsViewModel(id: "1", name: "Name 1"),
        const ExpansibleGroupsViewModel(id: "2", name: "Name 2"),
        const ExpansibleGroupsViewModel(id: "3", name: "Name 3"),
        const ExpansibleGroupsViewModel(id: "4", name: "Name 4"),
      ]);
      isLoading = false;
    } catch (e) {
      _expansibleGroups.subject
          .addError(UIError.unexpected.description, StackTrace.current);
    }
  }

  @override
  void goToProductsPage() {
    navigateTo = "/products";
  }

  @override
  void goToCartPage() {
    navigateTo = "/cart";
  }
}
