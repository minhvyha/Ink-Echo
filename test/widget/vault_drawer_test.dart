import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/utils/vault_book_list.dart';
import 'package:inkandecho/widgets/vault/vault_drawer.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('drawer navigates and changes sort order', (tester) async {
    useTallTestSurface(tester);
    var sort = VaultSortOrder.newest;
    var settingsOpened = false;
    var addOpened = false;

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: const Text('Open menu'),
              ),
            ),
          ),
          drawer: VaultDrawer(
            sortOrder: sort,
            onSortChanged: (value) => sort = value,
            onOpenSettings: () => settingsOpened = true,
            onAddReflection: () => addOpened = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open menu'));
    await tester.pumpAndSettle();

    expect(find.text('Your reading journal'), findsOneWidget);

    await tester.tap(find.text('Title A–Z'));
    await tester.pumpAndSettle();
    expect(sort, VaultSortOrder.title);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(settingsOpened, isTrue);

    await tester.tap(find.text('Open menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add reflection'));
    await tester.pumpAndSettle();
    expect(addOpened, isTrue);
  });
}
