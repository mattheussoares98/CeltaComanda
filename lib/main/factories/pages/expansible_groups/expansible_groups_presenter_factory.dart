import '../../../../main/factories/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

ExpansibleGroupsPresenter makeGetxExpansibleGroupsPresenter() =>
    GetxExpansibleGroupsPresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      navigateTo: makeNavigateTo(),
      localEnterpriseData: makeLocalEnterpriseData(),
    );
