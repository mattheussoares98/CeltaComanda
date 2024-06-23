import 'package:clean_celta_mobile/presentation/presenters/presenters.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:faker/faker.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  late CommentsPresenter sut;

  late CommentsSpy comments;

  late String newComment;
  late List<String> localComments;

  void initUseCases() {
    comments = CommentsSpy();
  }

  void initPresenters() {
    sut = GetxCommentsPresenter(comments: comments);
  }

  void initEntitys() {
    newComment = faker.randomGenerator.string(10);
    localComments = [
      faker.randomGenerator.string(10),
      faker.randomGenerator.string(10),
    ];
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

    verify(() => comments.add(sut.usedComments));
  });

  test("Should add newComment correctly in usedComments", () async {
    await sut.addComment(newComment);

    expect(sut.usedComments, [newComment]);
  });

  test("Should not add newComment if already exists", () async {
    await sut.addComment(newComment);
    await sut.addComment(newComment);

    expect(sut.usedComments, [newComment]);
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

    expect(sut.usedComments, localComments);
  });

  test("Should udpate usedComments correctly on LoadComments throws", () async {
    comments.mockLoadCommentsError();

    await sut.loadComments();

    expect(sut.usedComments, []);
  });
}
