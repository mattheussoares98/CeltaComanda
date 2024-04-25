import 'package:clean_celta_mobile/main/factories/pages/expansible_groups/local_clear_expansible_groups_factory.dart';
import 'package:clean_celta_mobile/main/factories/usecases/usecases.dart';

import '../../../../presentation/presenters/getx_expansible_groups_presenter.dart';
import '../../../../ui/pages/pages.dart';
import 'remote_load_expansible_groups_factory.dart';

ExpansibleGroupsPresenter makeGetxExpansibleGroupsPresenter() =>
    GetxExpansibleGroupsPresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      navigateTo: makeNavigateTo(),
      localEnterpriseData: makeLocalEnterpriseData(),
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      loadPrintedProducts: makeRemoteLoadPrintedProducts(),
      clearExpansibleGroups: makeLocalClearExpansibleGroups(),
    );
