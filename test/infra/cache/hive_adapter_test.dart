import 'dart:io';

import 'package:clean_celta_mobile/infra/cache/cache.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';
import 'package:hive/hive.dart';

import '../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HiveAdapter sut;
  late HiveSpy hive;
  late Box<dynamic> box;
  late dynamic value;
  late String result;
  late BoxSpy mockHiveBox;
  late String key;

  setUp(() async {
    hive = HiveSpy();
    mockHiveBox = BoxSpy();

    result = faker.randomGenerator.string(50);
    value = faker.randomGenerator.string(50);
    key = CacheKeys.hiveBoxName.name;

    hive.mockOpenBox(mockHiveBox);
    mockHiveBox.mockGet(result);
    mockHiveBox.mockDelete(key);
    mockHiveBox.mockPut(key, value);

    var path = Directory.current.path;
    hive.init(path);

    box = await hive.openBox(path);
    sut = HiveAdapter(box: box);
  });

  group('save', () {
    test('Should call localStorage with correct values', () async {
      await sut.put(key, value);

      verify(() => mockHiveBox.delete(key)).called(1);
      verify(() => mockHiveBox.put(key, value)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockHiveBox.mockDeleteError();

      final future = sut.put(key, value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('Should throw if deleteItem throws', () async {
      mockHiveBox.mockDeleteError();

      final future = sut.delete(CacheKeys.hiveBoxName.name);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('Should throw if deleteItem throws', () async {
      mockHiveBox.mockPutError();

      final future = sut.put(key, value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call localStorage with correct values', () async {
      await sut.delete(key);

      verify(() => mockHiveBox.delete(key)).called(1);
    });

    test('Should throw if deleteItem throws', () async {
      mockHiveBox.mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('get', () {
    test('Should call localStorage with correct value', () async {
      await sut.get(key);

      verify(() => mockHiveBox.get(key)).called(1);
    });

    test('Should return same value as localStorage', () async {
      final data = await sut.get(key);

      expect(data, result);
    });

    test('Should throw if getItem throws', () async {
      mockHiveBox.mockGetError();

      final future = sut.get(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
