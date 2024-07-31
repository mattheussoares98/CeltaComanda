import 'package:flutter/material.dart';

import 'components.dart';

class AnimatedAlertDialog {
  static bool isOpen = false;

  static Future<void> open({
    required BuildContext context,
    required Widget page,
    List<Widget>? actions,
  }) async {
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
                child: AnimatedDialog(page: page, actions: actions),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  final Widget page;
  final List<Widget>? actions;
  const AnimatedDialog({
    super.key,
    required this.page,
    required this.actions,
  });

  @override
  AnimatedDialogState createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
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
        iconPadding: const EdgeInsets.all(0),
        titlePadding: const EdgeInsets.all(0),
        buttonPadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        actions: widget.actions ?? [],
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: widget.page,
        ),
      ),
    );
  }
}
