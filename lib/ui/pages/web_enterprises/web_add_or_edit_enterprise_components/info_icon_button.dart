import 'package:flutter/material.dart';

class InfoIconButton extends StatelessWidget {
  final String toltipMessage;
  const InfoIconButton({
    required this.toltipMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      tooltip: toltipMessage,
      icon: Icon(
        Icons.info,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    );
  }
}
