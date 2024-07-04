import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

class AnimationManager {
  AnimationManager._();

  static late AnimationController _controller;
  static late Animation<double> _animation;

  static void initializeAnimation() {
    _controller = AnimationController(
      vsync: _MyTickerProvider(),
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  static bool _loaded = false;

  static Animation getAnimation({
    required double begin,
    required double end,
  }) {
    if (!_loaded) {
      _loaded = true;
      initializeAnimation();
    }

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Escolha a curva desejada aqui
    );

    _animation = Tween<double>(begin: begin, end: end).animate(curvedAnimation);
    return _animation;
  }

  static AnimationController get controller => _controller;

  static void dispose() {
    _controller.dispose();
  }
}

class _MyTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
