import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';
import '../../helpers/sizes/sizes.dart';

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
      maxNrOfCacheObjects: 100,
      stalePeriod: const Duration(days: 1),
    ),
  );

  static final Set<String> _failedUrls = {};

  @override
  Widget build(BuildContext context) {
    String url =
        "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/${(ean == null || ean?.isEmpty == true) ? plu : ean}.PNG";

    if (_failedUrls.contains(url)) {
      return _defaultImage(
        height: height,
        width: width,
        cacheManager: _customCacheManager,
      );
    }

    return CachedNetworkImage(
      fit: hasMinWidth(context) ? BoxFit.fitHeight : BoxFit.contain,
      memCacheHeight: 5 * 1024 * 1024,
      memCacheWidth: 5 * 1024 * 1024,
      cacheManager: _customCacheManager,
      key: ValueKey<String>(url),
      imageUrl: url,
      height: height,
      width: width,
      errorWidget: (context, url, error) {
        _failedUrls.add(url);
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
