import 'package:equatable/equatable.dart';

import '../../../ui/pages/pages.dart';

class InsertProductsViewModel extends Equatable {
  final Map<SelectedOptionType, dynamic> selectedOptions;

  const InsertProductsViewModel({
    required this.selectedOptions,
  });

  @override
  List<Object?> get props => [selectedOptions];
}
