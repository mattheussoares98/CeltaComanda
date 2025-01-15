import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

WebAllEnterprisesPresenter makeGetxWebAllEnterprisesPresenter() =>
    GetxWebAllEnterprisesPresenter(
      loadAllEnterprises: makeRemoteLoadAllEnterprises(),
      navigateTo: makeNavigateTo(),
    );
