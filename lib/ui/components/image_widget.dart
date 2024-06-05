import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter/material.dart';

import '../../infra/helpers/helperts.dart';
import '../../main/builders/builders.dart';

class ImageWidget extends StatelessWidget {
  final String?
      ean; //precisa o ean ou plu pra carregar a imagem do concentrador
  final String plu; //precisa o ean ou plu pra carregar a imagem do concentrador
  final double height;
  final double width;
  final bool showLargeImageInShowDialog;
  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
    required this.showLargeImageInShowDialog,
    super.key,
  });

  static showLargeImage({
    required BuildContext context,
    required String? ean,
    required String plu,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 8),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.7,
                child: _cachedImage(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  ean: ean,
                  plu: plu,
                  customCacheManager: _customCacheManager,
                ),
              ),
            ),
          );
        });
  }

  static final _customCacheManager = CacheManager(
    Config(
      CacheKeys.images.name,
      stalePeriod: const Duration(days: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GestureDetector(
        onTap: !showLargeImageInShowDialog
            ? null
            : () {
                showLargeImage(
                  context: context,
                  ean: ean,
                  plu: plu,
                );
              },
        child: _cachedImage(
          width: width,
          height: height,
          ean: ean,
          plu: plu,
          customCacheManager: _customCacheManager,
        ),
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
      "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl!}/Images/${ean ?? plu}.PNG";

  return CachedNetworkImage(
    cacheManager: customCacheManager,
    key: UniqueKey(),
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
  return SizedBox(
    height: height,
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey[350],
        ),
        const FittedBox(
            child: Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            "SEM IMAGEM",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        )),
      ],
    ),
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
