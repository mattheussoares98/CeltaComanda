import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import '../../../infra/helpers/helperts.dart';
import '../../../main/builders/builders.dart';

class CachedImage extends StatefulWidget {
  final String? ean;
  final String plu;
  final double height;
  final double width;
  final bool zoomImage;
  const CachedImage({
    required this.ean,
    required this.plu,
    required this.height,
    required this.width,
    this.zoomImage = true,
    super.key,
  });

  @override
  CachedImageState createState() => CachedImageState();
}

class CachedImageState extends State<CachedImage> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        String url =
            "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/${(widget.ean == null || widget.ean?.isEmpty == true) ? widget.plu : widget.ean}.PNG";

        await _imageHasAValidSize(url);
      }
    });
  }

  static final _customCacheManager = CacheManager(
    Config(
      CacheKeys.images.name,
      maxNrOfCacheObjects: 1000,
      stalePeriod: Duration(hours: 1),
    ),
  );

  static final Set<String> _failedUrls = {};
  static final Set<String> _largeImages = {};
  static final Set<String> _correctImages = {};

  Future<void> _imageHasAValidSize(String url) async {
    if (_largeImages.contains(url) || _failedUrls.contains(url)) {
      return;
    }
    try {
      final maxSizeInBytes = 3 * 1024 * 1024;
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);
      StreamSubscription<List<int>>? subscription;
      int totalBytes = 0;
      final completer = Completer<void>();
      subscription = response.stream.listen(
        (List<int> data) {
          totalBytes += data.length;

          if (totalBytes > maxSizeInBytes) {
            _largeImages.add(url);
            subscription?.cancel();
            completer.completeError('Tamanho máximo da imagem excedido $url');
          }
        },
        onDone: () {
          _correctImages.add(url);
          completer.complete();
        },
        onError: (error) {
          _failedUrls.add(url);
          completer.completeError(error);
        },
        cancelOnError: true,
      );
    } catch (e) {
      _failedUrls.add(url);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String url =
        "${EnterpriseDataBuilder.enterpriseDataEntity!.concentradorUrl}/Images/${(widget.ean == null || widget.ean?.isEmpty == true) ? widget.plu : widget.ean}.PNG";

    if (_failedUrls.contains(url) || _largeImages.contains(url)) {
      return _defaultImage(
        height: widget.height,
        width: widget.width,
        cacheManager: _customCacheManager,
      );
    }

    return CachedNetworkImage(
      fit: EnterpriseDataBuilder.enterpriseDataEntity?.zoomImage == true &&
              widget.zoomImage
          ? BoxFit.fitWidth
          : BoxFit.contain,
      cacheManager: _customCacheManager,
      key: ValueKey<String>(url),
      imageUrl: url,
      height: widget.height,
      width: widget.width,
      errorWidget: (context, url, error) {
        _failedUrls.add(url);
        return _defaultImage(
          height: widget.height,
          width: widget.width,
          cacheManager: _customCacheManager,
        );
      },
      placeholder: (context, url) {
        return _defaultImage(
          height: widget.height,
          width: widget.width,
          cacheManager: _customCacheManager,
        );
      },
    );
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
}
