import '../../../../presentation/presenters/presenters.dart';
import '../../factories.dart';

GetxHomePresenter makeGetxHomePresenter() => GetxHomePresenter(
      loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
      localEnterpriseData: makeLocalEnterpriseData(),
      navigateTo: makeNavigateTo(),
      ticketIsPermitted: makeRemoteticketIsPermitted(),
    );
