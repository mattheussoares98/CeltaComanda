import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late RemoteLoginData sut;
  late FirebaseStorageSpy firebaseStorage;
  late FirebaseFirestoreSpy firebaseFirestore;
  late LoginDataEntity loginData;
  late CollectionReference<Object?> collection;
  late Map data;

  setUpAll(() async {});

  setUp(() {
    data = CacheFactory.makeLoginData();
    firebaseStorage = FirebaseStorageSpy();
    firebaseFirestore = FirebaseFirestoreSpy();
    firebaseStorage.mockGet(data);
    loginData = LoginDataEntity(
      url: faker.internet.httpUrl(),
      userName: faker.person.name(),
      enterpriseName: faker.job.title(),
    );
    sut = RemoteLoginData(
      firebaseStorage: firebaseStorage,
      loginDataEntity: loginData,
    );
  });

  test("teste get", () async {
    // when(() => firebaseFirestore.collection('clients').doc("senderID").get())
    //     .thenAnswer((_) => null);
  });

  // group('load', () {
  //   test('Should call cacheStorage with correct key', () async {
  //     await sut.load();

  //     verify(() => firebaseStorage.get(collection: )).called(1);
  //   });

  //   test('Should return a LoginData on success', () async {
  //     final loginDataEntity = await sut.load();

  //     expect(
  //       loginDataEntity,
  //       LoginDataEntity(
  //         url: data['url'],
  //         userName: data['userName'],
  //         enterpriseName: null,
  //       ),
  //     );
  //   });

  //   test('Should throw UnexpectedError if cache is empty', () async {
  //     firebaseStorage.mockGet({});

  //     final future = sut.load();

  //     expect(future, throwsA(DomainError.unexpected));
  //   });

  //   test('Should throw UnexpectedError if cache is isvalid', () async {
  //     firebaseStorage.mockGet(CacheFactory.makeInvalidLoginData());

  //     final future = sut.load();

  //     expect(future, throwsA(DomainError.unexpected));
  //   });

  //   test('Should throw UnexpectedError if cache is incomplete', () async {
  //     firebaseStorage.mockGet(CacheFactory.makeIncompleteLoginData());

  //     final future = sut.load();

  //     expect(future, throwsA(DomainError.unexpected));
  //   });

  //   test('Should throw UnexpectedError if cache throws', () async {
  //     firebaseStorage.mockGetError();

  //     final future = sut.load();

  //     expect(future, throwsA(DomainError.unexpected));
  //   });
  // });

  // group('validate', () {
  //   test('Should call cacheStorage with correct key', () async {
  //     await sut.validate();

  //     verify(() => cacheStorage.get(CacheKeys.loginData.name)).called(1);
  //   });

  //   test('Should delete cache if it is invalid', () async {
  //     cacheStorage.mockGet(CacheFactory.makeInvalidLoginData());

  //     await sut.validate();

  //     verify(() => cacheStorage.delete(CacheKeys.loginData.name)).called(1);
  //   });

  //   test('Should delete cache if it is incomplete', () async {
  //     cacheStorage.mockGet(CacheFactory.makeIncompleteLoginData());

  //     await sut.validate();

  //     verify(() => cacheStorage.delete(CacheKeys.loginData.name)).called(1);
  //   });

  //   test('Should delete cache if get fails', () async {
  //     cacheStorage.mockGetError();

  //     await sut.validate();

  //     verify(() => cacheStorage.delete(CacheKeys.loginData.name)).called(1);
  //   });
  // });
}
