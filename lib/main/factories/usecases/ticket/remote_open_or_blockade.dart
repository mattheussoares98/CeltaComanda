import '../../../../data/usecases/ticket/remote_open_or_blockade.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/factories.dart';

OpenOrBlockade makeRemoteOpenOrBlockad() => RemoteOpenOrBlockade(
      httpAdapter: makeHttpAdapter(),
    );
