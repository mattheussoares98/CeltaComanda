import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:get/get.dart';

import '../../data/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/expansible_groups/expansible_groups.dart';
import '../mixins/mixins.dart';

class GetxExpansibleGroupsPresenter extends GetxController
    with LoadingManager
    implements ExpansibleGroupsPresenter {
  final NavigateTo navigateTo;
  final LocalEnterpriseData localEnterpriseData;
  GetxExpansibleGroupsPresenter({
    required this.loadExpansibleGroups,
    required this.navigateTo,
    required this.localEnterpriseData,
  });

  late final LoadExpansibleGroups loadExpansibleGroups;
  final _expansibleGroups = Rx<List<ExpansibleGroupsViewModel>>([]);

  @override
  Stream<List<ExpansibleGroupsViewModel>> get expansibleGroupsStream =>
      _expansibleGroups.stream;

  @override
  Future<void> load() async {
    try {
      final expansibleGroups = await loadExpansibleGroups.load();
      isLoading = true;

      if (expansibleGroups != null) {
        _expansibleGroups.subject.add(
          expansibleGroups
              .map((e) => ExpansibleGroupsViewModel(
                    name: e.Name,
                  ))
              .toList(),
        );
      }

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
  Future<void> goToSplashPage() async {
    navigateTo.navigate(pageRoute: PageRoutes.splash, clear: true);
  }

  @override
  Future<void> clearEnterpriseData() async {
    EnterpriseDataBuilder.enterpriseDataEntity = null;
    await localEnterpriseData.add(
      const EnterpriseEntity(enterpriseName: ""),
    );
  }
}
