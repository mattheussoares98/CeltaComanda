import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class CartPageDialog {
  static bool isOpen = false;

  static Future<void> open(BuildContext context) async {
    isOpen = true;

    await showDialog(
      context: context,
      builder: (context) {
        return Dismissible(
          direction: DismissDirection.startToEnd,
          key: UniqueKey(),
          onDismissed: (_) {
            Navigator.of(context).pop();
            isOpen = false;
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    isOpen = false;
                  },
                  child: Container(
                    height: double.infinity,
                    color: Colors.transparent,
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: ClosePageIconButton(),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: _AnimatedDialog(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedDialog extends StatefulWidget {
  @override
  __AnimatedDialogState createState() => __AnimatedDialogState();
}

class __AnimatedDialogState extends State<_AnimatedDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        insetPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const CartPage(),
        ),
      ),
    );
  }
}
