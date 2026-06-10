// [FIREBASE-AUTH-ACTIVE-START]
import 'package:firebase_auth/firebase_auth.dart';
// [FIREBASE-AUTH-ACTIVE-END]

import '../../../infra/databases/databases.dart';

// [FIREBASE-AUTH-ACTIVE-START]
FirebaseAuthAdapter makeFirebaseAuthAdapter() => FirebaseAuthAdapter(
      firebaseAuth: FirebaseAuth.instance,
    );
// [FIREBASE-AUTH-ACTIVE-END]
// [FIREBASE-AUTH-INACTIVE-START]
// FirebaseAuthAdapter makeFirebaseAuthAdapter() => FirebaseAuthAdapter();
// [FIREBASE-AUTH-INACTIVE-END]
