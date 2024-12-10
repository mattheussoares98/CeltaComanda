import 'dart:convert';

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

      final parametersEncoded =
          jsonEncode(value.map((element) => element.toJson()).toList());

      await hiveStorage.put(CacheKeys.parameters.name, parametersEncoded);
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
        return [];
      }

      final responseDecoded = json.decode(response);
      return responseDecoded
          .map((e) => ParameterModel.fromJson(e))
          .toList()
          .cast<ParameterModel>();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
  }
}
