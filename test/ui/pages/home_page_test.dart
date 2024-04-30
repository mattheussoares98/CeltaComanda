import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import '../helpers/helpers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(
        makePage(path: PageRoutes.home, page: () => const HomePage()));
  }

  testWidgets('Should present SearchCommandIcon on AppBar',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byKey(const Key("SearchCommandIcon")), findsOneWidget);
  });
}
