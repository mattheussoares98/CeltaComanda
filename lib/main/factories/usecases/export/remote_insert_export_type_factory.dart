import 'package:clean_celta_mobile/data/usecases/export/export.dart';

import '../../../../domain/usecases/usecases.dart';
import '../../factories.dart';

InsertExportLoadType makeRemoteInsertExportLoadType() =>
    RemoteInsertExportLoadType(
      httpClient: makeHttpAdapter(),
    );
