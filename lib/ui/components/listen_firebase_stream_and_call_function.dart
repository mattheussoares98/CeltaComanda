import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ListenFirebaseStreamAndCallFunction extends StatefulWidget {
  final String collection;
  final String doc;
  final Widget child;
  final Future<void> Function(Map<String, dynamic> data) function;
  const ListenFirebaseStreamAndCallFunction({
    required this.collection,
    required this.doc,
    required this.child,
    required this.function,
    super.key,
  });

  @override
  State<ListenFirebaseStreamAndCallFunction> createState() =>
      _ListenFirebaseStreamAndCallFunctionState();
}

class _ListenFirebaseStreamAndCallFunctionState
    extends State<ListenFirebaseStreamAndCallFunction> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  static bool _isUpdatingMenu = false;

  @override
  initState() {
    super.initState();

    final docRef = FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(widget.doc);
    stream = docRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !_isUpdatingMenu) {
          Future.delayed(Duration.zero, () async {
            final data = snapshot.data!.data();

            if (data != null) {
              _isUpdatingMenu = true;
              await widget.function(data);
              _isUpdatingMenu = false;
            }
          });
        }
        return widget.child;
      },
    );
  }
}
