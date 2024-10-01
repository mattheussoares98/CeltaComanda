import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

CovenantPresenter makeGetxCovenantPresenter() => GetxCovenantPresenter(
      loadCustomer: makeRemoteLoadCustomer(),
    );
