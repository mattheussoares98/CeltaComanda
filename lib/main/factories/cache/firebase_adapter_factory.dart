import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../infra/databases/databases.dart';

FirebaseAdapter makeFirebaseAdapter() =>
    FirebaseAdapter(firestore: FirebaseFirestore.instance);
