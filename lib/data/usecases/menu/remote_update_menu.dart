import '../../../domain/usecases/usecases.dart';
import '../../database/database.dart';

class RemoteUpdateMenu implements UpdateMenu {
  final FirebaseStorage firebaseAdapter;

  RemoteUpdateMenu({
    required this.firebaseAdapter,
  });

  @override
  Future<void> update() async {
    try {
      await firebaseAdapter.updateMenu();
    } catch (e) {
      throw Exception();
    }
  }
}
