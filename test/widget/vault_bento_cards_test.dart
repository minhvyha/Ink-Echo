import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/widgets/vault/vault_bento_cards.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('featured card shows book title and handles tap', (tester) async {
    var tapped = false;
    final book = sampleBook(title: 'Featured Title');

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultFeaturedCard(
          book: book,
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Featured Title'), findsOneWidget);
    await tester.tap(find.text('Featured Title'));
    expect(tapped, isTrue);
  });

  testWidgets('new entry card triggers write callback', (tester) async {
    var wrote = false;

    await tester.pumpWidget(
      wrapWithInkEchoTheme(
        VaultNewEntryCard(onWrite: () => wrote = true),
      ),
    );
    await tester.pump();

    expect(find.text('Start a New Entry'), findsOneWidget);
    await tester.tap(find.text('Write Now'));
    expect(wrote, isTrue);
  });
}
