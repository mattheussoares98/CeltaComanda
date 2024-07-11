import 'package:cached_network_image/cached_network_image.dart';
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
  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
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
    return ClipRRect(
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
      return _imageNotExists(height: height, width: width);
    },
    placeholder: (context, url) {
      return _loadingImage();
    },
  );
}

Widget _imageNotExists({
  required double height,
  required double width,
}) {
  return Image.asset(
    "lib/ui/assets/images/imageNotFound.png",
    height: height,
    width: width,
  );
}

Widget _loadingImage() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: CircularProgressIndicator(
      strokeWidth: 2,
    ),
  );
}
