import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final void Function()? onTap;
  final Widget leading;
  final String name;
  const DrawerItem({
    required this.onTap,
    required this.leading,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            )),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: leading,
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
