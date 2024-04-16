import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/expansible_groups/expansible_groups.dart';
import '../mixins/mixins.dart';

class GetxExpansibleGroupsPresenter extends GetxController
    with LoadingManager
    implements ExpansibleGroupsPresenter {
  final NavigateTo navigateTo;
  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
  });

  late final LoadExpansibleGroups loadExpansibleGroups;
  final _expansibleGroups = Rx<List<ExpansibleGroupsViewModel>>([]);

  @override
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream =>
      _expansibleGroups.stream;

  @override
  Future<void> load() async {
    try {
      await loadExpansibleGroups.load();
      await Future.delayed(const Duration(seconds: 1));
      isLoading = true;
      await Future.delayed(const Duration(seconds: 3));
      _expansibleGroups.subject.add([
        const ExpansibleGroupsViewModel(name: "Name 1"),
        const ExpansibleGroupsViewModel(name: "Name 2"),
      ]);
      isLoading = false;
    } catch (e) {
      _expansibleGroups.subject
          .addError(UIError.unexpected.description, StackTrace.current);
      throw DomainError.unexpected;
    }
  }

  @override
  void goToProductsPage() {
    navigateTo.navigate(pageRoute: PageRoutes.products);
  }

  @override
  void goToCartPage() {
    navigateTo.navigate(pageRoute: PageRoutes.cart);
  }

  @override
  void goToSplashPage() {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
  }
}
