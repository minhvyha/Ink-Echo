import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/book_detail_page.dart';
import 'package:inkandecho/pages/reflection_page.dart';

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

  testWidgets('shows Added and Last updated metadata', (tester) async {
    final book = sampleBook(
      createdAt: DateTime(2025, 5, 10),
      updatedAt: DateTime(2025, 6, 1),
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(BookDetailPage(book: book)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Added:'), findsOneWidget);
    expect(find.textContaining('May 10, 2025'), findsOneWidget);
    expect(find.textContaining('Last updated:'), findsOneWidget);
    expect(find.textContaining('Jun 1, 2025'), findsOneWidget);
  });

  testWidgets('shows edit and delete actions', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(BookDetailPage(book: sampleBook())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
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

  testWidgets('delete shows confirmation dialog and cancel keeps page',
      (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(BookDetailPage(book: sampleBook())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete entry?'), findsOneWidget);
    expect(find.textContaining('cannot be undone'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete entry?'), findsNothing);
    expect(find.text('Edit'), findsOneWidget);
  });

  testWidgets('confirming delete removes entry and pops route', (tester) async {
    final service = await createSeededBookService(
      id: 'delete-me',
      title: 'To Remove',
      echo: 'Gone soon',
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => BookDetailPage(
                book: sampleBook(id: 'delete-me', title: 'To Remove'),
                bookService: service,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await pumpBrief(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Delete'),
      ),
    );
    await pumpBrief(tester, const Duration(milliseconds: 600));

    expect(find.text('To Remove'), findsNothing);
    expect(find.byType(BookDetailPage), findsNothing);

    final remaining = await readTestBookDocs();
    expect(remaining, isEmpty);
  });

  testWidgets('edit opens reflection form with existing title', (tester) async {
    final book = sampleBook(title: 'Editable Title', author: 'Author');

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => BookDetailPage(book: book),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await pumpBrief(tester, const Duration(milliseconds: 500));

    expect(find.byType(ReflectionPage), findsOneWidget);
    expect(find.text('Edit entry'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller?.text,
      'Editable Title',
    );
  });
}
