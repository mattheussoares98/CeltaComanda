import '../../../../main/factories/factories.dart';
import '../../../../ui/pages/pages.dart';

CovenantPage makeCovenantPage() => CovenantPage(
      covenantPresenter: makeGetxCovenantPresenter(),
    );
