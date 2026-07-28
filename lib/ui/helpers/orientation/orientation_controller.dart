import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrientationController extends StatefulWidget {
  final Widget child;
  const OrientationController({super.key, required this.child});

  @override
  State<OrientationController> createState() => _OrientationControllerState();
}

class _OrientationControllerState extends State<OrientationController> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setOrientation(context);
  }

  void setOrientation(BuildContext context) {
    // Get the shortest side of the screen.
    // This is the best way to determine if the device is a "tablet"
    // because it doesn't change with orientation.
    final double shortestSide = MediaQuery.of(context).size.shortestSide;

    if (activePlatform.isPaymentPlatform) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // debugPrint("portrait");
    } else if (shortestSide >= 600) {
      // If the shortest side is 600 logical pixels or more, allow landscape.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // debugPrint("landscape");
    } else {
      // Otherwise, lock to portrait mode.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      // debugPrint("portrait");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
