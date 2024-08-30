import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

UserValidations makeRemoteUserValidations() => RemoteUserValidations(
      httpAdapter: makeHttpAdapter(),
    );
