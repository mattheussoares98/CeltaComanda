import 'package:flutter/widgets.dart';

class AppBarTitle extends StatelessWidget {
  final int currentIndex;
  final String? commandNumber;
  const AppBarTitle({
    required this.currentIndex,
    required this.commandNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "Produtos",
      "Produtos impressos",
      "Pendentes para impressão",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            titles[currentIndex],
            style: const TextStyle(fontSize: 20),
          ),
        ),
        if (commandNumber != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Comanda ${commandNumber!}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }
}
