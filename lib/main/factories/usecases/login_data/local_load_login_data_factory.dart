
import '../../../../data/usecases/login_data/login_data.dart';
import '../../factories.dart';

LocalLoginData makeLocalLoadLoginData() =>
    LocalLoginData(hiveStorage: makeHiveAdapter());
