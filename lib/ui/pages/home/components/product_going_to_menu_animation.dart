import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../pages.dart';

class ProductGoingToMenuAnimation extends StatefulWidget {
  const ProductGoingToMenuAnimation({super.key});

  @override
  State<ProductGoingToMenuAnimation> createState() =>
      _ProductGoingToMenuAnimationState();
}

class _ProductGoingToMenuAnimationState
    extends State<ProductGoingToMenuAnimation>
    with SingleTickerProviderStateMixin {
  bool _isAnimatig = false;
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds:
            AnimationManager.animateNavigationBarItemDurationMilliseconds,
      ),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);
  }

  void doAnimation() {
    if (!_isAnimatig) {
      _isAnimatig = true;
      _animationController?.reset();
      _animationController?.forward();

      Future.delayed(
          Duration(
            milliseconds: AnimationManager
                .animateNavigationBarItemDurationMilliseconds,
          ), () {
        _isAnimatig = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return StreamBuilder<bool>(
        stream: cartPresenter.animateProductGoingMenuToCartStream,
        builder: (context, snapshot) {
          if (snapshot.data != true) {
            return const SizedBox();
          } else {
            return AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                doAnimation();

                return Positioned(
                  bottom: kBottomNavigationBarHeight / 2 + 10,
                  left: (MediaQuery.of(context).size.width /
                          (homePresenter.isGeneratingVersionToRede ? 7 : 6)) +
                      (_animation!.value *
                          ((MediaQuery.of(context).size.width /
                                  (homePresenter.isGeneratingVersionToRede
                                      ? 7
                                      : 6)) *
                              2)) -
                      5,
                  child: SizedBox(
                    height: kBottomNavigationBarHeight / 2 - 5,
                    width: kBottomNavigationBarHeight / 2 - 5,
                    child: Image.asset(
                      "lib/ui/assets/images/product_animation.png",
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
