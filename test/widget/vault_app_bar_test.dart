import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/widgets/vault/vault_app_bar.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('default bar shows menu, brand, and search actions', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultAppBar(
          searchActive: false,
          searchController: TextEditingController(),
          searchFocusNode: FocusNode(),
          onMenuTap: () {},
          onSearchTap: () {},
          onSearchClose: () {},
          onSearchChanged: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text('Ink & Echo'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('tapping menu and search invokes callbacks', (tester) async {
    var menuTapped = false;
    var searchTapped = false;

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultAppBar(
          searchActive: false,
          searchController: TextEditingController(),
          searchFocusNode: FocusNode(),
          onMenuTap: () => menuTapped = true,
          onSearchTap: () => searchTapped = true,
          onSearchClose: () {},
          onSearchChanged: (_) {},
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.tap(find.byIcon(Icons.search));

    expect(menuTapped, isTrue);
    expect(searchTapped, isTrue);
  });

  testWidgets('search mode shows field and filters via callback', (tester) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    var query = '';

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultAppBar(
          searchActive: true,
          searchController: controller,
          searchFocusNode: focus,
          onMenuTap: () {},
          onSearchTap: () {},
          onSearchClose: () {},
          onSearchChanged: (value) => query = value,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pump();

    expect(query, 'dune');
    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(query, '');
    expect(controller.text, isEmpty);

    controller.dispose();
    focus.dispose();
  });
}
