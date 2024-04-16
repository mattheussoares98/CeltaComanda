import '../../../../data/http/http.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../domain/helpers/helpers.dart';
import '../../../../domain/usecases/usecases.dart';

class RemoteLoadExpansibleGroups implements LoadExpansibleGroups {
  final HttpClient httpAdapter;

  RemoteLoadExpansibleGroups({required this.httpAdapter});

  @override
  Future<List<ExpansibleGroupEntity>?> load() async {
    try {
      // final products = await httpAdapter.request(url: "url", method: "get");
      // if (products == null) throw Error();
      return const [
        ExpansibleGroupEntity(name: "Expansible Group Name"),
      ];
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
