import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

ExpansibleGroupFromProductPresenter makeGetxExpansibleGroupFromProductPresenter() =>
    GetxExpansibleGroupFromProductPresenter(
      loadExpansibleGroupsFromProductsComplete:
          makeRemoteLoadExpansibleGroupsFromProductsComplete(),
    );
