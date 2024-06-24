import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalComments implements Comments {
  final HiveStorage hiveStorage;

  LocalComments({required this.hiveStorage});

  @override
  Future<void> add(List<String> comments) async {
    try {
      await hiveStorage.delete(CacheKeys.comments.name);

      final commentsEncoded = jsonEncode(comments);

      await hiveStorage.put(CacheKeys.comments.name, commentsEncoded);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<String>?> load() async {
    try {
      final value = await hiveStorage.get(
        CacheKeys.comments.name,
      );

      if (value == null) {
        return null;
      } else {
        final decoded = jsonDecode(value) as List<dynamic>;
        final localComments = decoded.cast<String>();

        return localComments;
      }
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
