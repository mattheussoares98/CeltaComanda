import 'dart:convert';

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadOpenSaleRequest implements LoadOpenSaleRequest {
  final HttpClient httpAdapter;

  RemoteLoadOpenSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<List<SaleRequestModel>> load() async {
    final settings = await _loadSettingsFromServedAsset();

    final String? url = settings['url'];
    final int? enterpriseId = settings['enterpriseId'];
    final bool? isConsiderDelivered = settings['isConsiderDelivered'];
    final int considerDelivered = isConsiderDelivered == true ? 1 : 0;

    if (url == null || enterpriseId == null) {
      throw Exception('URL or Enterprise ID missing from settings file.');
    }

    final response = await httpAdapter.request(
      url:
          "$url/api/apiSaleRequest/GetAll?_enterpriseId=$enterpriseId&isConsiderDelivered=$considerDelivered",
      method: "get",
    );

    return (response as List).map((e) => SaleRequestModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> _loadSettingsFromServedAsset() async {
    if (!kIsWeb) {
      return {
        'url': EnterpriseBuilder.entity!.url,
        'enterpriseId': EnterpriseBuilder.entity!.enterpriseId,
        'isConsiderDelivered': true
      };
    }

    String settingsUrl = '${Uri.base.removeFragment()}settings.txt';

    final response = await httpAdapter.request(
      url: settingsUrl,
      method: "get",
    );

    if (response is String) {
      // Decode the raw text content received from the HTTP response
      return jsonDecode(response);
    }
    // Handle case where httpAdapter might already decode JSON
    if (response is Map<String, dynamic>) {
      return response;
    }

    throw Exception(
        'Failed to load or decode settings file from server asset.');
  }
}
