import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String comment;

  const CommentEntity({
    required this.comment,
  });

  @override
  List get props => [comment];
}
