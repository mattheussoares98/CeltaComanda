
import '../../../../data/usecases/enterprise/enterprise.dart';
import '../../factories.dart';

LocalEnterpriseData makeLocalEnterpriseData() =>
    LocalEnterpriseData(hiveStorage: makeHiveAdapter());
