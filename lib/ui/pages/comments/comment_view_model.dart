// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class CommentViewModel implements Equatable {
  final String comment;
  bool selected = false;

  CommentViewModel({
    required this.comment,
    required this.selected,
  });

  factory CommentViewModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['comment', 'selected'])) {
      throw Exception();
    }
    return CommentViewModel(
      comment: json['comment'],
      selected: json['selected'],
    );
  }

  factory CommentViewModel.fromEntity(CommentEntity entity) => CommentViewModel(
        comment: entity.comment,
        selected: false,
      );

  CommentEntity toEntity() => CommentEntity(
        comment: comment,
      );

  Map<String, dynamic> toJson() => {"comment": comment, "selected": selected};

  @override
  List<Object?> get props => [comment, selected];

  @override
  bool? get stringify => throw UnimplementedError();
}
