import 'package:flutter/material.dart';

import '../../../data/models/parameters_model.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../database/database.dart';

class LocalParametersData implements ParametersData {
  final HiveStorage hiveStorage;

  LocalParametersData({required this.hiveStorage});

  @override
  Future<void> update(List<ParametersModel> value) async {
    try {
      await hiveStorage.delete(CacheKeys.parameters.name);
      await hiveStorage.put(CacheKeys.parameters.name, value);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
  }

  @override
  Future<List<ParametersModel>> load() async {
    try {
      final response = await hiveStorage.get(
        CacheKeys.parameters.name,
      );

      if (response == null) {
        throw Exception();
      }

      return response
          .map((e) => ParametersModel.fromJson(e))
          .toList()
          .cast<ParametersModel>();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
  }
}
