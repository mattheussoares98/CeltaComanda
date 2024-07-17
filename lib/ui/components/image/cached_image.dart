import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';

class CachedImage extends StatelessWidget {
  final String? ean;
  final String plu;
  final double height;
  final double width;
  const CachedImage({
    required this.ean,
    required this.plu,
    required this.height,
    required this.width,
    super.key,
  });

  static final _customCacheManager = CacheManager(
    Config(
      CacheKeys.images.name,
      stalePeriod: const Duration(days: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    String url =
        "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/${ean ?? plu}.PNG";

    return CachedNetworkImage(
      fit: BoxFit.contain,
      cacheManager: _customCacheManager,
      key: ValueKey<String>(url),
      imageUrl: url,
      height: height,
      width: width,
      errorWidget: (context, url, error) {
        return _defaultImage(
          height: height,
          width: width,
          cacheManager: _customCacheManager,
        );
      },
      placeholder: (context, url) {
        return _defaultImage(
          height: height,
          width: width,
          cacheManager: _customCacheManager,
        );
      },
    );
  }
}

Widget _defaultImage({
  required double height,
  required double width,
  required BaseCacheManager? cacheManager,
}) {
  final url =
      "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/Enterprise${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}/Logo.png";
  return CachedNetworkImage(
    fit: BoxFit.contain,
    cacheManager: cacheManager,
    key: ValueKey<String>(url),
    imageUrl: url,
    height: height,
    width: width,
    errorWidget: (context, url, error) {
      return Image.asset(
        "lib/ui/assets/images/imageNotFound.png",
        height: height,
        width: width,
      );
    },
    placeholder: (context, url) {
      return Image.asset(
        "lib/ui/assets/images/imageNotFound.png",
        height: height,
        width: width,
      );
    },
  );
}
