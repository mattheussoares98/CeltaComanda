import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  late GetxCommentsPresenter sut;

  late LoadExpansibleGroupsFromProductsCompleteSpy
      loadExpansibleGroupsFromProductsComplete;

  late CommentViewModel newUnselectedComment;

  void initUseCases() {
    loadExpansibleGroupsFromProductsComplete =
        LoadExpansibleGroupsFromProductsCompleteSpy();
  }

  void initPresenters() {
    sut = GetxCommentsPresenter(
      loadExpansibleGroupsFromProductsComplete:
          loadExpansibleGroupsFromProductsComplete,
    );
  }

  void initEntitys() {
    newUnselectedComment = EntityFactory.makeCommentViewModel();
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

    await sut.addComment(newUnselectedComment);
  });

  test("Should add newComment correctly in usedComments", () async {
    await sut.addComment(newUnselectedComment);

    expect(sut.loadedComments, [newUnselectedComment]);
  });

  test("Should not add newComment if already exists", () async {
    final first = CommentViewModel(comment: "comment", selected: false);
    final second = CommentViewModel(comment: "comment", selected: true);
    await sut.addComment(first);
    await sut.addComment(second);

    expect(sut.loadedComments.length, 1);
  });

  test("Should enable selected comment if try add equal comment", () async {
    await sut.addComment(newUnselectedComment);
    await sut.addComment(newUnselectedComment);

    expect(sut.loadedComments[0].selected, true);
  });

  test("Should emit correct values on loadLocalComments succeeds", () async {
    expectLater(sut.isLoadingStream, emitsInAnyOrder([true, false]));
    expectLater(sut.mainErrorStream, emits(null));

    await sut.loadComments();
  });

  test("Should update comment isSelected correctly", () async {
    await sut.addComment(newUnselectedComment);
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
    newUnselectedComment.selected = true;
    await sut.addComment(newUnselectedComment);
    await sut.addComment(newUnselectedComment);

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

  test("Should update correctly hasSelectedComments add new comment", () async {
    await sut.addComment(CommentViewModel(
      comment: faker.randomGenerator.string(10),
      selected: true,
    ));

    expect(sut.hasSelectedComments, true);
  });

  test(
      "Should return null in getConcatenateSelectedComments if dont have selected comments",
      () async {
    sut.addComment(newUnselectedComment);

    final concatenate = sut.getConcatenateSelectedComments();

    expect(concatenate, null);
  });

  test(
      "Should return concatenateComments in getConcatenateSelectedComments if has selected comments",
      () async {
    final selectedComment = EntityFactory.makeCommentViewModel(selected: true);
    sut.addComment(selectedComment);

    final concatenate = sut.getConcatenateSelectedComments();

    expect(concatenate, selectedComment.comment);
  });

  test(
      "Should update correctly selected comments in sut.updateSelectedComments",
      () async {
    final firstComment = EntityFactory.makeCommentViewModel(selected: false);
    final secondComment = EntityFactory.makeCommentViewModel(selected: false);

    await sut.addComment(firstComment);
    await sut.addComment(secondComment);

    sut.updateSelectedComments(
        "${firstComment.comment}\n${secondComment.comment}");

    expect(sut.loadedComments[0].selected, true);
    expect(sut.loadedComments[1].selected, true);
  });

  test(
      "Should update correctly selected comments in sut.updateSelectedComments if pass null parameter",
      () async {
    await sut.addComment(EntityFactory.makeCommentViewModel(selected: true));

    sut.updateSelectedComments(null);

    expect(sut.loadedComments[0].selected, false);
  });

  group("Delete comment", () {
    test("Should delete commentViewModel correctly", () async {
      await sut.addComment(EntityFactory.makeCommentViewModel());

      expect(sut.loadedComments.length, 1);

      await sut.deleteComment(0);
      expect(sut.loadedComments.length, 0);
    });

    test("Should emit correct values on delete comment success", () async {
      expectLater(
          sut.isLoadingStream, emitsInAnyOrder([true, false, true, false]));
      expectLater(sut.mainErrorStream, emits(null));

      await sut.addComment(newUnselectedComment);
      await sut.deleteComment(0);
    });
  });
}
