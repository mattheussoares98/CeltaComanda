import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

class AnimationManager {
  AnimationManager._();

  static late AnimationController _controller;
  static late Animation<double> _animation;

  static void initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: _MyTickerProvider(), // Substitua pelo seu TickerProvider adequado
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -0.4, end: 0.4).animate(_controller);
  }

  static bool _loaded = false;
  static Animation<double> get animation {
    if (!_loaded) {
      _loaded = true;
      initializeAnimation();
    }
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
