import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ListenFirebaseStreamAndCallFunction extends StatelessWidget {
  final String collection;
  final String doc;
  final Widget child;
  final String keyToListen;
  final Future<void> Function(Map<String, dynamic> data) function;
  const ListenFirebaseStreamAndCallFunction({
    required this.collection,
    required this.doc,
    required this.child,
    required this.keyToListen,
    required this.function,
    super.key,
  });

  static bool _isUpdatingMenu = false;

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(doc);
    final stream = docRef.snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !_isUpdatingMenu) {
          Future.delayed(Duration.zero, () async {
            final data = snapshot.data!.data();

            if (data != null && data.containsKey(keyToListen)) {
              _isUpdatingMenu = true;
              await function(data);
              _isUpdatingMenu = false;
            }
          });
        }
        return child;
      },
    );
  }
}
