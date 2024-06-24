import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

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
    await sut.addComment(newComment);

    expect(sut.loadedComments, [newComment]);
  });

  test("Should not add newComment if already exists", () async {
    await sut.addComment(newComment);
    await sut.addComment(newComment);

    expect(sut.loadedComments, [newComment]);
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

    await sut.loadComments();

    expect(sut.loadedComments, localComments);
  });

  test("Should update usedComments correctly on LoadComments throws", () async {
    comments.mockLoadCommentsError();
    await sut.addComment(newComment);

    await sut.loadComments();

    expect(sut.loadedComments, []);
  });

  test("Should update comment isSelected correctly", () async {
    await sut.addComment(newComment);
    expect(sut.loadedComments[0].selected, false);

    sut.changeCommentIsSelected(0);

    expect(sut.loadedComments[0].selected, true);

    sut.changeCommentIsSelected(0);
    expect(sut.loadedComments[0].selected, false);
  });

  test("Should unselect all comments correctly", () async {
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));

    sut.unselectAllComments();

    expect(sut.loadedComments[0].selected, false);
    expect(sut.loadedComments[1].selected, false);
  });

  test(
      "Should update correctly hasSelectedComments when call updateHasSelectedComment",
      () async {
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));

    sut.updateHasSelectedComments();
    expect(sut.hasSelectedComments, true);

    sut.loadedComments[0].selected = false;
    sut.updateHasSelectedComments();
    expect(sut.hasSelectedComments, true);

    sut.loadedComments[1].selected = false;
    sut.updateHasSelectedComments();
    expect(sut.hasSelectedComments, false);
  });

  test(
      "Should update correctly hasSelectedComments when call unselectAllComments",
      () async {
    newComment.selected = true;
    await sut.addComment(newComment);
    await sut.addComment(newComment);

    sut.updateHasSelectedComments();
    expect(sut.hasSelectedComments, true);

    sut.unselectAllComments();

    expect(sut.hasSelectedComments, false);
  });

  test(
      "Should update correctly hasSelectedComments when call changeCommentIsSelected",
      () async {
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));

    sut.changeCommentIsSelected(0);
    expect(sut.hasSelectedComments, true);

    sut.changeCommentIsSelected(1);
    expect(sut.hasSelectedComments, false);
  });
}
