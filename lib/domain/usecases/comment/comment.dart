abstract class Comments {
  Future<void> add(List<String> comments);
  Future<List<String>?> load();
}
