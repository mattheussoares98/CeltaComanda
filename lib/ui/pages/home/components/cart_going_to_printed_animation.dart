import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../pages.dart';

class CartGoingToPrintedAnimation extends StatefulWidget {
  const CartGoingToPrintedAnimation({super.key});

  @override
  State<CartGoingToPrintedAnimation> createState() =>
      _CartGoingToPrintedAnimationState();
}

class _CartGoingToPrintedAnimationState
    extends State<CartGoingToPrintedAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds:
            AnimationManager.animateNavigationBarItemDurationMilliseconds,
      ),
      vsync: this,
    )..repeat(); // Configura a animação para repetir indefinidamente e com reversão

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return StreamBuilder<bool>(
      stream: cartPresenter.animateCartGoingToPrintedProductsStream,
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox(); // Retorna um SizedBox vazio se não há animação
        } else {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                bottom: kBottomNavigationBarHeight / 2 + 10,
                left: (MediaQuery.of(context).size.width /
                        (homePresenter.isGeneratingVersionToRede ? 2.5 : 8)) +
                    (_animation.value *
                        ((MediaQuery.of(context).size.width /
                                (homePresenter.isGeneratingVersionToRede
                                    ? 2.5
                                    : 8)) *
                            0.7)) -
                    5,
                child: SizedBox(
                  height: kBottomNavigationBarHeight / 2 - 5,
                  width: kBottomNavigationBarHeight / 2 - 5,
                  child: Image.asset(
                    "lib/ui/assets/images/empty_cart.jpg",
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
