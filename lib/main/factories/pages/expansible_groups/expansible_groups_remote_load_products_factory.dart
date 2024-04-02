import '../../../../data/usecases/load_expansible_groups/remote_load_expansible_groups.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../factories/factories.dart';

LoadExpansibleGroups makeRemoteLoadExpansibleGroups() => RemoteLoadExpansibleGroups(
      httpAdapter: makeHttpAdapter(),
    );
