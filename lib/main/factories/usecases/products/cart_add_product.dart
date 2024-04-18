import '../../../../data/usecases/products/products.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../main/factories/factories.dart';

AddProduct makeCartAddProduct() => CartAddProduct(
      cartPresenter: makeGetxCartPresenter(),
    );
