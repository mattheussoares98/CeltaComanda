import '../../../../domain/usecases/usecases.dart';
import '../../../../data/usecases/usecases.dart';
import '../../factories.dart';

LoadCommandsAvailable makeRemoteLoadCommandsAvailable() => RemoteLoadCommandsAvailable(
      httpAdapter: makeHttpAdapter(),
    );
