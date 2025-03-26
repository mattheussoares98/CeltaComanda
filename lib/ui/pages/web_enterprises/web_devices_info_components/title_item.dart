import 'package:flutter/material.dart';

import '../../pages.dart';

class TitleItem extends StatelessWidget {
  final void Function(List<DeviceInfoViewModel>? data) sort;
  final List<DeviceInfoViewModel> data;
  final String title;
  const TitleItem({
    required this.sort,
    required this.title,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 2, 4),
        child: ElevatedButton(
            onPressed: () {
              sort(data);
            },
            child: Text(
              title,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
