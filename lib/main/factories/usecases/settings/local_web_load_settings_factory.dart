import 'package:clean_celta_mobile/main/factories/http/http_client_factory.dart';

import '../../../../data/usecases/settings/settings.dart';
import '../../../../domain/usecases/usecases.dart';

WebLoadSettings makeLocalWebLoadSettings() =>
    LocalWebLoadSettings(makeHttpAdapter());
