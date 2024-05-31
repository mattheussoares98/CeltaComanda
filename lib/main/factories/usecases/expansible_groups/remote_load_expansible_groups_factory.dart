import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

LoadExpansibleGroups makeRemoteLoadExpansibleGroups() => RemoteLoadExpansibleGroups(
      httpAdapter: makeHttpAdapter(),
    );
