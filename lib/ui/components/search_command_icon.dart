import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home/home.dart';

class SearchCommandIcon extends StatefulWidget {
  final Future Function() loadCommandData;
  const SearchCommandIcon({
    required this.loadCommandData,
    super.key,
  });

  @override
  State<SearchCommandIcon> createState() => _SearchCommandIconState();
}

class _SearchCommandIconState extends State<SearchCommandIcon> {
  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return GestureDetector(
      key: const Key("SearchCommandIcon"),
      onTap: () async {
        await widget.loadCommandData();
      },
      child: FittedBox(
        child: Stack(
          children: [
            IconButton(
              icon: Icon(
                homePresenter.commandEntity?.isFixedCommandNumber == true
                    ? Icons.refresh
                    : Icons.find_replace_rounded,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              onPressed: () async {
                await widget.loadCommandData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
