import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../components.dart';

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

    _animation =
        Tween<double>(begin: widget.beginAnimation!, end: widget.endAnimation!)
            .animate(curvedAnimation);
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
          child: ClipRRect(
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
