import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

ConfigurationsPage makeConfigurationsPage() => ConfigurationsPage(
      configurationsPresenter: makeConfigurationsPresenter(),
    );
