// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/cache/cache.dart';

import 'package:mocktail/mocktail.dart';

class FirebaseStorageSpy extends Mock implements FirebaseStorage {
  FirebaseStorageSpy() {
    this.mockUpdate();
    // this.mockAdd();
  }

  When mockGetCall() => when(() => this.get(
        collection: any(named: 'collection'),
        fieldToSearch: any(named: 'fieldToSearch'),
        valueToSearch: any(named: 'fieldToSearch'),
      ));
  void mockGet(dynamic data) =>
      this.mockGetCall().thenAnswer((_) async => data);
  void mockGetError() => this.mockGetCall().thenThrow(Exception());

  When mockUpdateCall() => when(() => this.addNewPrintRequest(any()));
  void mockUpdate() => this.mockUpdateCall().thenAnswer((_) async => _);
  void mockUpdateError() => this.mockUpdateCall().thenThrow(Exception());

  // When mockAddCall() => when(() => this.add(
  //       enterpriseEntity: any(named: "enterpriseEntity"),
  //       collection: any(named: "collection"),
  //     ));
  // void mockAdd() => this.mockAddCall().thenAnswer((_) async => _);
  // void mockAddError() => this.mockAddCall().thenThrow(Exception());
}
