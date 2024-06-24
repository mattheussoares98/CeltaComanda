import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  late GetxCommentsPresenter sut;

  late CommentsSpy comments;

  late CommentViewModel newComment;
  late List<CommentViewModel> localComments;

  void initUseCases() {
    comments = CommentsSpy();
  }

  void initPresenters() {
    sut = GetxCommentsPresenter(comments: comments);
  }

  void initEntitys() {
    newComment = EntityFactory.makeCommentViewModel();
    localComments = [newComment];
  }

  void mockSuccess() {}

  setUp(() {
    initUseCases();
    initPresenters();
    initEntitys();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeEnterpriseData());
  });

  test("Should emit correct values on add new local comment succeeds",
      () async {
    expectLater(sut.isLoadingStream, emitsInAnyOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(null));

    await sut.addComment(newComment);
  });

  test("Should emit correct values on add new local comment throws", () async {
    comments.mockAddCommentsError();

    expectLater(sut.isLoadingStream, emitsInAnyOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInAnyOrder([null, UIError.unexpected]));

    await sut.addComment(newComment);
  });

  test("Should call addNewComment with correct comments", () async {
    await sut.addComment(newComment);

    verify(() => comments.add(localComments)).called(1);
  });

  test("Should add newComment correctly in usedComments", () async {
    expectLater(sut.localCommentsStream, emits([newComment]));

    await sut.addComment(newComment);
  });

  test("Should not add newComment if already exists", () async {
    expectLater(sut.localCommentsStream, emits([newComment]));

    await sut.addComment(newComment);
    await sut.addComment(newComment);
  });

  test("Should emit correct values on loadLocalComments succeeds", () async {
    expectLater(sut.isLoadingStream, emitsInAnyOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(null));

    await sut.loadComments();
  });

  test("Should emit correct values on loadLocalComments throws", () async {
    comments.mockLoadCommentsError();

    expectLater(sut.isLoadingStream, emitsInAnyOrder([true, false]));
    expectLater(
        sut.mainErrorStream, emitsInAnyOrder([null, UIError.unexpected]));

    await sut.loadComments();
  });

  test("Should udpate usedComments correctly on LoadComments succeeds",
      () async {
    comments.mockLoadComments(localComments);
    expectLater(sut.localCommentsStream, emits(localComments));

    await sut.loadComments();
  });

  test("Should udpate usedComments correctly on LoadComments throws", () async {
    comments.mockLoadCommentsError();
    expectLater(sut.localCommentsStream, emits([]));

    await sut.loadComments();
  });
}
