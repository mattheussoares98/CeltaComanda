import '../../../domain/entities/entities.dart';

class RemoteLoadProducts {
  final String name;
  final String plu;
  final double price;
  final String image;

  RemoteLoadProducts({
    required this.name,
    required this.plu,
    required this.price,
    required this.image,
  });

  factory RemoteLoadProducts.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['name', 'plu', 'price', 'image'])) {
      throw Exception();
    }

    return RemoteLoadProducts(
      name: json["name"],
      plu: json["plu"],
      price: json["price"],
      image: json["image"],
    );
  }

  ProductEntity toEntity() => ProductEntity(
        name: name,
        plu: plu,
        image: image,
        price: price,
      );
}
