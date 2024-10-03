import 'package:clean_celta_mobile/main/factories/pages/covenant/customer_validation_factory.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

CovenantPresenter makeGetxCovenantPresenter() => GetxCovenantPresenter(
      loadCustomer: makeRemoteLoadCustomer(),
      validation: makeCustomerValidation(),
      finishSaleRequestConcentrador: makeRemoteFinishSaleRequestConcentrador(),
    );
