import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter/material.dart';

import '../../infra/helpers/helperts.dart';
import '../../main/builders/builders.dart';

class ImageWidget extends StatefulWidget {
  final String?
      ean; //precisa o ean ou plu pra carregar a imagem do concentrador
  final String plu; //precisa o ean ou plu pra carregar a imagem do concentrador
  final double height;
  final double width;
  final bool showLargeImageInShowDialog;
  final String? productComplement;
  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
    required this.showLargeImageInShowDialog,
    required this.productComplement,
    super.key,
  });

  static showLargeImage({
    required BuildContext context,
    required String? ean,
    required String? productComplement,
    required String plu,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  content: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ImageWidget(
                          ean: ean,
                          plu: plu,
                          productComplement: productComplement,
                          showLargeImageInShowDialog: false,
                          height: MediaQuery.of(context).size.height * 0.9,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      if (productComplement != null)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(productComplement),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    size: 40,
                  ),
                ),
              ),
            ],
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
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationManager.animation;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: GestureDetector(
        onTap: !widget.showLargeImageInShowDialog
            ? null
            : () {
                ImageWidget.showLargeImage(
                  context: context,
                  ean: widget.ean,
                  plu: widget.plu,
                  productComplement: widget.productComplement,
                );
              },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(_animation.value, 0),
              child: _cachedImage(
                width: widget.width * 1.2, // Aumenta a largura da imagem
                height: widget.height,
                ean: widget.ean,
                plu: widget.plu,
                customCacheManager: ImageWidget._customCacheManager,
              ),
            );
          },
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
