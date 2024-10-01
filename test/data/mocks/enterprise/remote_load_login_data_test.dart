// import 'package:clean_celta_mobile/data/usecases/enterprise_data/enterprise_data.dart';
// import 'package:clean_celta_mobile/domain/entities/entities.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:faker/faker.dart';
// import 'package:flutter_test/flutter_test.dart';

// import '../../../infra/mocks/mocks.dart';
// import '../../mocks/mocks.dart';

// void main() {
//   late RemoteEnterpriseData sut;
//   late FirebaseStorageSpy firebaseStorage;
//   late FirebaseFirestoreSpy firebaseFirestore;
//   late EnterpriseDataEntity enterpriseData;
//   late CollectionReference<Object?> collection;
//   late Map data;

//   setUpAll(() async {});

//   setUp(() {
//     data = CacheFactory.makeEnterpriseData();
//     firebaseStorage = FirebaseStorageSpy();
//     firebaseFirestore = FirebaseFirestoreSpy();
//     firebaseStorage.mockGet(data);
//     enterpriseData = EnterpriseDataEntity(
//       url: faker.internet.httpUrl(),
//       userName: faker.person.name(),
//       enterpriseName: faker.job.title(),
//     );
//     sut = RemoteEnterpriseData(
//       firebaseStorage: firebaseStorage,
//       enterpriseDataEntity: enterpriseData,
//     );
//   });

//   test("teste get", () async {
//     // when(() => firebaseFirestore.collection('clients').doc("senderID").get())
//     //     .thenAnswer((_) => null);
//   });

//   // group('load', () {
//   //   test('Should call cacheStorage with correct key', () async {
//   //     await sut.load();

//   //     verify(() => firebaseStorage.get(collection: )).called(1);
//   //   });

//   //   test('Should return a EnterpriseData on success', () async {
//   //     final enterpriseDataEntity = await sut.load();

//   //     expect(
//   //       enterpriseDataEntity,
//   //       EnterpriseDataEntity(
//   //         url: data['url'],
//   //         userName: data['userName'],
//   //         enterpriseName: null,
//   //       ),
//   //     );
//   //   });

//   //   test('Should throw UnexpectedError if cache is empty', () async {
//   //     firebaseStorage.mockGet({});

//   //     final future = sut.load();

//   //     expect(future, throwsA(DomainError.unexpected));
//   //   });

//   //   test('Should throw UnexpectedError if cache is isvalid', () async {
//   //     firebaseStorage.mockGet(CacheFactory.makeInvalidEnterpriseData());

//   //     final future = sut.load();

//   //     expect(future, throwsA(DomainError.unexpected));
//   //   });

//   //   test('Should throw UnexpectedError if cache is incomplete', () async {
//   //     firebaseStorage.mockGet(CacheFactory.makeIncompleteEnterpriseData());

//   //     final future = sut.load();

//   //     expect(future, throwsA(DomainError.unexpected));
//   //   });

//   //   test('Should throw UnexpectedError if cache throws', () async {
//   //     firebaseStorage.mockGetError();

//   //     final future = sut.load();

//   //     expect(future, throwsA(DomainError.unexpected));
//   //   });
//   // });

//   // group('validate', () {
//   //   test('Should call cacheStorage with correct key', () async {
//   //     await sut.validate();

//   //     verify(() => cacheStorage.get(CacheKeys.enterpriseData.name)).called(1);
//   //   });

//   //   test('Should delete cache if it is invalid', () async {
//   //     cacheStorage.mockGet(CacheFactory.makeInvalidEnterpriseData());

//   //     await sut.validate();

//   //     verify(() => cacheStorage.delete(CacheKeys.enterpriseData.name)).called(1);
//   //   });

//   //   test('Should delete cache if it is incomplete', () async {
//   //     cacheStorage.mockGet(CacheFactory.makeIncompleteEnterpriseData());

//   //     await sut.validate();

//   //     verify(() => cacheStorage.delete(CacheKeys.enterpriseData.name)).called(1);
//   //   });

//   //   test('Should delete cache if get fails', () async {
//   //     cacheStorage.mockGetError();

//   //     await sut.validate();

//   //     verify(() => cacheStorage.delete(CacheKeys.enterpriseData.name)).called(1);
//   //   });
//   // });
// }
