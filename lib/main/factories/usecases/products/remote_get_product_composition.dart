import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/http/http_client_factory.dart';

GetProductComposition makeRemoteGetProductComposition() =>
    RemoteGetProductComposition(
      makeHttpAdapter(),
    );
