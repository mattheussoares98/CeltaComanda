import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class ZoomImageSwitch extends StatelessWidget {
  final bool zoomImage;
  final void Function() changeZoom;
  const ZoomImageSwitch({
    required this.zoomImage,
    required this.changeZoom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          changeZoom();
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(R.string.zoomImage)),
              Switch(
                value: zoomImage,
                onChanged: (_) {
                  changeZoom();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
