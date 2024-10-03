import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/factories.dart';

AuthorizeCovenantLimitUseByCode makeRemoteAuthorizeCovenantLimitUseByCode() =>
    RemoteAuthorizeCovenantLimitUseByCode(
      soapAdapter: makeSoapAdapter(),
    );
