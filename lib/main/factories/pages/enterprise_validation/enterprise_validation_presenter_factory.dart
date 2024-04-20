import 'package:clean_celta_mobile/presentation/presenters/getx_enterprise_validation_presenter.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

EnterpriseValidationPresenter makeGetxEnterpriseValidationPresenter() =>
    GetxEnterpriseValidationPresenter(
      validation: makeEnterpriseValidation(),
      localLoginData: makeLocalLoadLoginData(),
      remoteLoginData: makeRemoteLoginData(),
      navigateTo: makeNavigateTo(),
      loadApiSaleRequest: makeRemoteLoadApiSaleRequest(),
    );
