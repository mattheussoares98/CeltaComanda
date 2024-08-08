import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/databases/databases.dart';

SecureStorageAdapter makeSecureStorageAdapter() =>
    SecureStorageAdapter(secureStorage: const FlutterSecureStorage());
