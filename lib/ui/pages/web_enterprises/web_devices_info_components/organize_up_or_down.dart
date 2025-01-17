import 'package:flutter/material.dart';

import '../../pages.dart';

class OrganizeUpOrDown extends StatelessWidget {
  final void Function(List<DeviceInfoViewModel>? data) sortDown;
  final void Function(List<DeviceInfoViewModel>? data) sortUp;
  final List<DeviceInfoViewModel> data;
  final String title;
  const OrganizeUpOrDown({
    required this.sortDown,
    required this.sortUp,
    required this.title,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  sortDown(data);
                },
                icon: Icon(Icons.arrow_downward),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(title),
              ),
              IconButton(
                onPressed: () {
                  sortUp(data);
                },
                icon: Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
