import '../../../../data/usecases/expansible_groups/expansible_groups.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../factories/factories.dart';

LoadExpansibleGroups makeRemoteLoadExpansibleGroups() => RemoteLoadExpansibleGroups(
      httpAdapter: makeHttpAdapter(),
    );
