import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

WebEnterprisesPresenter makeGetxWebEnterprisesPresenter() =>
    GetxWebEnterprisesPresenter(
      loadAllEnterprises: makeRemoteLoadAllEnterprises(),
      navigateTo: makeNavigateTo(),
      updateDeviceInformations: makeRemoteUpdateDeviceInformations(),
      updateEnterpriseParameters: makeRemoteUpdateEnterpriseParameters(),
    );
