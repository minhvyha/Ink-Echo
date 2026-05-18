import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/book_detail_page.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('displays book metadata and reflection', (tester) async {
    final book = sampleBook(
      title: 'Piranesi',
      author: 'Susanna Clarke',
      echo: 'The Beauty of the House is immeasurable.',
      mood: 'Atmospheric',
      transcription: 'A remembered line',
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(BookDetailPage(book: book)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Piranesi'), findsOneWidget);
    expect(find.text('Susanna Clarke'), findsOneWidget);
    expect(find.text('ATMOSPHERIC'), findsOneWidget);
    expect(
      find.textContaining('Beauty of the House'),
      findsOneWidget,
    );
    expect(find.text('A remembered line'), findsOneWidget);
  });

  testWidgets('back button pops the route', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => BookDetailPage(book: sampleBook()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });
}
