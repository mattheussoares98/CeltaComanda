import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String comment;
  final bool isSelected;

  const CommentEntity({
    required this.comment,
    required this.isSelected,
  });

  @override
  List get props => [comment, isSelected];
}
