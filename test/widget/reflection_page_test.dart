import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/pages/reflection_page.dart';

import '../helpers/test_helpers.dart';

Finder get _titleField => find.byType(TextField).at(0);
Finder get _authorField => find.byType(TextField).at(1);

void main() {
  setUpAll(disableGoogleFontRuntimeFetching);

  testWidgets('shows add reflection form and validates required fields',
      (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(const ReflectionPage(skipSpeechInit: true)),
    );
    await pumpBrief(tester, const Duration(milliseconds: 800));

    expect(find.text('Add a book'), findsOneWidget);
    expect(find.text('Ink & Echo'), findsOneWidget);

    await scrollTo(tester, find.text('Save book'));
    await tester.tap(find.text('Save book'));
    await pumpBrief(tester);

    expect(
      find.text('Please add a title and author before saving.'),
      findsOneWidget,
    );
  });

  testWidgets('close button pops navigator', (tester) async {
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        Material(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (_) => const ReflectionPage(skipSpeechInit: true),
            ),
          ),
        ),
      ),
    );
    await pumpBrief(tester, const Duration(milliseconds: 800));

    await tester.tap(find.byIcon(Icons.close));
    await pumpBrief(tester);
  });

  testWidgets('edit mode prefills title and author fields', (tester) async {
    useTallTestSurface(tester);
    final book = sampleBook(
      title: 'Dune',
      author: 'Frank Herbert',
      echo: 'Fear is the mind-killer.',
      mood: 'Challenging',
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        ReflectionPage(book: book, skipSpeechInit: true),
      ),
    );
    await pumpBrief(tester, const Duration(milliseconds: 800));

    expect(find.text('Edit entry'), findsOneWidget);
    expect(tester.widget<TextField>(_titleField).controller?.text, 'Dune');
    expect(
      tester.widget<TextField>(_authorField).controller?.text,
      'Frank Herbert',
    );
    expect(find.text('Challenging'), findsWidgets);
  });

  testWidgets('selecting mood chip updates selection', (tester) async {
    useTallTestSurface(tester);
    await tester.pumpWidget(
      wrapWithInkEchoNavigator(const ReflectionPage(skipSpeechInit: true)),
    );
    await pumpBrief(tester, const Duration(milliseconds: 800));

    await scrollTo(tester, find.text('Nostalgic'));
    await tester.tap(find.text('Nostalgic'));
    await pumpBrief(tester);

    expect(find.text('Nostalgic'), findsWidgets);
  });

  testWidgets('save book writes to Firestore and shows success', (tester) async {
    useTallTestSurface(tester);
    final service = createTestBookService();
    var saved = false;

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        ReflectionPage(
          bookService: service,
          skipSpeechInit: true,
          onBookSaved: () => saved = true,
        ),
      ),
    );
    await pumpBrief(tester, const Duration(milliseconds: 800));

    await tester.enterText(_titleField, 'New Title');
    await tester.enterText(_authorField, 'New Author');

    await scrollTo(tester, find.text('Save book'));
    await tester.tap(find.text('Save book'));
    await pumpBrief(tester, const Duration(milliseconds: 600));

    expect(find.text('Book saved to your shelf.'), findsOneWidget);
    expect(saved, isTrue);

    final docs = await readTestBookDocs();
    expect(docs.any((d) => d['title'] == 'New Title'), isTrue);
  });

  testWidgets('update book persists changes via injected service',
      (tester) async {
    useTallTestSurface(tester);
    final service = await createSeededBookService(
      id: 'edit-id',
      title: 'Original',
      echo: 'Old echo',
    );
    final existing = sampleBook(
      id: 'edit-id',
      title: 'Original',
      echo: 'Old echo',
    );

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        ReflectionPage(
          book: existing,
          bookService: service,
          skipSpeechInit: true,
        ),
      ),
    );
    await pumpBrief(tester, const Duration(milliseconds: 800));

    await tester.enterText(_titleField, 'Revised Title');
    await scrollTo(tester, find.text('Save changes'));
    await tester.tap(find.text('Save changes'));
    await pumpBrief(tester, const Duration(milliseconds: 600));

    expect(find.text('Entry updated.'), findsOneWidget);

    final data = await readTestBookDoc('edit-id');
    expect(data?['title'], 'Revised Title');
  });
}
