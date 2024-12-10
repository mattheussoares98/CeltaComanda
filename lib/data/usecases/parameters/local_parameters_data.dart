import 'package:flutter/material.dart';

import '../../models/parameter_model.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../database/database.dart';

class LocalParametersData implements ParametersData {
  final HiveStorage hiveStorage;

  LocalParametersData({required this.hiveStorage});

  @override
  Future<void> update(List<ParameterModel> value) async {
    try {
      await hiveStorage.delete(CacheKeys.parameters.name);
      await hiveStorage.put(CacheKeys.parameters.name, value);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
  }

  @override
  Future<List<ParameterModel>> load() async {
    try {
      final response = await hiveStorage.get(
        CacheKeys.parameters.name,
      );

      if (response == null) {
        throw Exception();
      }

      return response
          .map((e) => ParameterModel.fromJson(e))
          .toList()
          .cast<ParameterModel>();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
  }
}
