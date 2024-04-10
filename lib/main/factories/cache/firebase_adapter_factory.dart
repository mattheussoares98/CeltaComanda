import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../infra/cache/cache.dart';

FirebaseAdapter makeFirebaseAdapter() =>
    FirebaseAdapter(firestore: FirebaseFirestore.instance);
