
import '../../../../data/usecases/enterprise/enterprise.dart';
import '../../factories.dart';

LocalEnterpriseData makeLocalLoadEnterpriseData() =>
    LocalEnterpriseData(hiveStorage: makeHiveAdapter());
