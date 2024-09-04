abstract class Persistent {
  Future<void> makePersistent();
  Future<void> makeNotPersistent();
  Future<void> closeApp();
}
