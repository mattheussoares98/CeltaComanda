import 'package:hive/hive.dart';

import '../../../infra/helpers/helpers.dart';
import '../../../infra/databases/databases.dart';

HiveAdapter makeHiveAdapter() =>
    HiveAdapter(box: Hive.box(CacheKeys.hiveBoxName.name));
