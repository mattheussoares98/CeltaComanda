import 'package:hive/hive.dart';

import '../../../infra/helpers/helperts.dart';
import '../../../infra/cache/cache.dart';

HiveAdapter makeHiveAdapter() =>
    HiveAdapter(box: Hive.box(CacheKeys.hiveBoxName.name));
