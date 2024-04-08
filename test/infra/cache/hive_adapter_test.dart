import 'dart:io';

import 'package:clean_celta_mobile/infra/cache/cache.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';
import 'package:hive/hive.dart';

import '../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

// class MockHiveBox extends Mock implements Box {}

void main() {
  late HiveAdapter sut;
  late HiveSpy hive;

  late Box<dynamic> box;
  late dynamic value;
  // late String result;

  late BoxSpy mockHiveBox;

  setUp(() async {
    hive = HiveSpy();
    mockHiveBox = BoxSpy();
    // result = faker.randomGenerator.string(50);
    value = faker.randomGenerator.string(50);

    hive.mockOpenBox(mockHiveBox);
    var path = Directory.current.path;
    hive.init(path);
    box = await hive.openBox(path);
    sut = HiveAdapter(box: box);
  });

  group('save', () {
    test('Should call localStorage with correct values', () async {
      when(() => mockHiveBox.delete(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockHiveBox.put(any(), any()))
          .thenAnswer((_) async => Future.value());

      await sut.put(CacheKeys.hiveBoxName.name, value);

      verify(() => mockHiveBox.delete(CacheKeys.hiveBoxName.name)).called(1);
      verify(() => mockHiveBox.put(CacheKeys.hiveBoxName.name, value))
          .called(1);
    });

    // test('Should throw if deleteItem throws', () async {
    //   hive.mockDeleteError();

    //   final future = sut.put(boxKey, value);

    //   expect(future, throwsA(const TypeMatcher<Exception>()));
    // });

    // test('Should throw if deleteItem throws', () async {
    //   hive.mockDeleteError();

    //   final future = sut.delete(CacheKeys.hiveBoxName.name);

    //   expect(future, throwsA(const TypeMatcher<Exception>()));
    // });

    //   test('Should throw if deleteItem throws', () async {
    //     localStorage.mockSaveError();

    //     final future = sut.save(key: key, value: value);

    //     expect(future, throwsA(const TypeMatcher<Exception>()));
    //   });
    // });
  });

  // group('delete', () {
  //   test('Should call localStorage with correct values', () async {
  //     await sut.delete(key);

  //     verify(() => localStorage.deleteItem(key)).called(1);
  //   });

  //   test('Should throw if deleteItem throws', () async {
  //     localStorage.mockDeleteError();

  //     final future = sut.delete(key);

  //     expect(future, throwsA(const TypeMatcher<Exception>()));
  //   });
  // });

  // group('get', () {
  //   test('Should call localStorage with correct value', () async {
  //     await sut.get(key);

  //     verify(() => localStorage.getItem(key)).called(1);
  //   });

  //   test('Should return same value as localStorage', () async {
  //     final data = await sut.get(key);

  //     expect(data, result);
  //   });

  //   test('Should throw if getItem throws', () async {
  //     localStorage.mockGetError();

  //     final future = sut.get(key);

  //     expect(future, throwsA(const TypeMatcher<Exception>()));
  //   });
  // });
}
