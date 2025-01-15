import 'package:clean_celta_mobile/domain/entities/enterprise_entity.dart';
import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxWebEnterprisesPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements WebEnterprisesPresenter {
  final LoadAllEnterprises loadAllEnterprises;
  final NavigateTo navigateTo;

  GetxWebEnterprisesPresenter({
    required this.loadAllEnterprises,
    required this.navigateTo,
  });

  @override
  Future<void> loadEnterprises() async {
    try {
      isLoading = true;
      mainError = null;
      enterprises = null;

      final result = await loadAllEnterprises.load();

      enterprises = result;
    } catch (error) {
      mainError = UIError.notFound;
    } finally {
      isLoading = false;
    }
  }

  final _enterprises = Rx<List<EnterpriseEntity>?>(null);
  @override
  Stream<List<EnterpriseEntity>?> get enterprisesStream => _enterprises.stream;
  set enterprises(List<EnterpriseEntity>? value) => _enterprises.value = value;

  @override
  void goToAddOrEditEnterprise(EnterpriseEntity? enterprise) {
    try {
      mainError = null;

      _selectedEnterprise = enterprise;
      navigateTo.navigate(pageRoute: PageRoutes.webAddOrEditEnterprise);
    } catch (e) {
      mainError = UIError.unexpected;
    }
  }

  EnterpriseEntity? _selectedEnterprise;
  @override
  EnterpriseEntity? get selectedEnterprise => _selectedEnterprise;
}
