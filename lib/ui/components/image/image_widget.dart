import 'package:flutter/material.dart';

import '../../pages/pages.dart';
import '../components.dart';

enum AnimationOrientation { horizontal, vertical }

class ImageWidget extends StatefulWidget {
  final String?
      ean; // precisa o ean ou plu pra carregar a imagem do concentrador
  final String
      plu; // precisa o ean ou plu pra carregar a imagem do concentrador
  final double height;
  final double width;
  final ProductsViewModel? selectedProduct;
  final AnimationOrientation orientation;

  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
    required this.selectedProduct,
    this.orientation = AnimationOrientation.horizontal,
    super.key,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation = Tween<double>(begin: 0, end: -20).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    widget.orientation == AnimationOrientation.vertical
                        ? Offset(0, _animation.value)
                        : Offset(_animation.value, 0),
                child: CachedImage(
                  ean: widget.ean,
                  plu: widget.plu,
                  height: widget.height,
                  width: widget.width,
                ),
              );
            },
          ),
        ),
        if (widget.selectedProduct?.ProductComplement
                .toString()
                .toLowerCase()
                .contains("(novo)") ==
            true)
          NewProductBadge(
            height: widget.height * 0.25,
            width: widget.width * 0.25,
          ),
        if (widget.selectedProduct?.ProductComplement
                .toString()
                .toLowerCase()
                .contains("(kids)") ==
            true)
          KidsBadge(
            height: widget.height * 0.25,
            width: widget.width * 0.25,
          ),
        if (widget.selectedProduct?.IsAlcoholicProduct == "true")
          AlcoholicBadge(
            height: widget.height * 0.25,
            width: widget.width * 0.25,
          ),
        PepperBadge(
          product: widget.selectedProduct,
          height: widget.height * 0.25,
          width: widget.width * 0.25,
        ),
      ],
    );
  }
}
