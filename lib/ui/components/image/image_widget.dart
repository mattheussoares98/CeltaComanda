import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../pages/pages.dart';
import '../components.dart';

class ImageWidget extends StatefulWidget {
  final String?
      ean; //precisa o ean ou plu pra carregar a imagem do concentrador
  final String plu; //precisa o ean ou plu pra carregar a imagem do concentrador
  final double height;
  final double width;
  final ProductsViewModel? selectedProduct;

  const ImageWidget({
    this.height = 65,
    this.width = 65,
    required this.ean,
    required this.plu,
    required this.selectedProduct,
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
      curve: Curves.easeInOut, // Escolha a curva desejada aqui
    );

    _animation = Tween<double>(begin: 1, end: 1.2).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: hasMinWidth(context) ? 4 : 2,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
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
                  height: widget.height * 0.4,
                  width: widget.width * 0.4,
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
          ),
        ),
      ],
    );
  }
}
