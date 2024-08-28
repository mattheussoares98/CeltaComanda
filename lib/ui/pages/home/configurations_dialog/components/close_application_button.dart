import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CloseApplicationButton extends StatelessWidget {
  const CloseApplicationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        const platform = MethodChannel('close_channel');

        try {
          Future.delayed(Duration.zero, () async {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
                overlays: []);
            final result = await platform.invokeMethod("close");
            debugPrint(result);
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      },
      child: const Text("Close app"),
    );
  }
}
