
import '../../../../data/usecases/login_data/login_data.dart';
import '../../factories.dart';

LocalLoginData makeLocalLoginData() =>
    LocalLoginData(hiveStorage: makeLocalStorageAdapter());
