import '../../../../presentation/presenters/getx_expansible_groups_presenter.dart';
import '../../../../ui/pages/pages.dart';
import 'expansible_groups_remote_load_products_factory.dart';

ExpansibleGroupsPresenter makeGetxExpansibleGroupsPresenter() =>
    GetxExpansibleGroupsPresenter(
      loadProducts: makeRemoteLoadExpansibleGroups(),
    );
