import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter/material.dart';

import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';

class ImageWidget extends StatefulWidget {
  final String?
      ean; //precisa o ean ou plu pra carregar a imagem do concentrador
  final String plu; //precisa o ean ou plu pra carregar a imagem do concentrador
  final double height;
  final double width;
  final double? beginAnimation;
  final double? endAnimation;
  final bool isAlcoholic;
  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
    required this.isAlcoholic,
    this.beginAnimation = 1,
    this.endAnimation = 0.7,
    super.key,
  });

  static final _customCacheManager = CacheManager(
    Config(
      CacheKeys.images.name,
      stalePeriod: const Duration(days: 1),
    ),
  );

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: hasMinWidth(context) ? 4 : 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AnimatedBuilder(
              animation: AnimationManager.getAnimation(
                begin: widget.beginAnimation!,
                end: widget.endAnimation!,
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: AnimationManager.getAnimation(
                    begin: widget.beginAnimation!,
                    end: widget.endAnimation!,
                  ).value,
                  child: _cachedImage(
                    width: widget.width,
                    height: widget.height,
                    ean: widget.ean,
                    plu: widget.plu,
                    customCacheManager: ImageWidget._customCacheManager,
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.isAlcoholic)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset(
                "lib/ui/assets/images/prohibed_for_minors.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}

Widget _cachedImage({
  required double width,
  required double height,
  required String? ean,
  required String plu,
  required CacheManager customCacheManager,
}) {
  String url =
      "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/${ean ?? plu}.PNG";

  return CachedNetworkImage(
    fit: BoxFit.contain,
    cacheManager: customCacheManager,
    key: ValueKey<String>(url),
    imageUrl: url,
    height: height,
    width: width,
    errorWidget: (context, url, error) {
      return _defaultImage(height: height, width: width);
    },
    placeholder: (context, url) {
      return _defaultImage(height: height, width: width);
    },
  );
}

Widget _defaultImage({
  required double height,
  required double width,
}) {
  final url =
      "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/Enterprise${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}/Logo.png";
  return CachedNetworkImage(
    fit: BoxFit.contain,
    cacheManager: ImageWidget._customCacheManager,
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
