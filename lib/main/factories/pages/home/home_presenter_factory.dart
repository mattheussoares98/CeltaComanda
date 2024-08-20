import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

HomePresenter makeGetxHomePresenter() => GetxHomePresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      localEnterpriseData: makeLocalEnterpriseData(),
      navigateTo: makeNavigateTo(),
      ticketIsPermitted: makeRemoteticketIsPermitted(),
      localCommandData: makeLocalUseFixedCommandNumber(),
      userValidations: makeRemoteUserValidations(),
      loadSaleRequestTemp: makeRemoteLoadSaleRequestTemp(),
      updateSaleRequestTemp: makeRemoteUpdateSaleRequestTemp(),
    );
