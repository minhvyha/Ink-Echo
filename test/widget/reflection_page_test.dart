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
      wrapWithInkEchoNavigator(const ReflectionPage()),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Add a book'), findsOneWidget);
    expect(find.text('Ink & Echo'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Save book'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save book'));
    await tester.pumpAndSettle();

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
              builder: (_) => const ReflectionPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
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
      wrapWithInkEchoNavigator(ReflectionPage(book: book)),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

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
      wrapWithInkEchoNavigator(const ReflectionPage()),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.scrollUntilVisible(
      find.text('Nostalgic'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Nostalgic'));
    await tester.pumpAndSettle();

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
          onBookSaved: () => saved = true,
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.enterText(_titleField, 'New Title');
    await tester.enterText(_authorField, 'New Author');

    await tester.scrollUntilVisible(
      find.text('Save book'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save book'));
    await tester.pumpAndSettle();

    expect(find.text('Book saved to your shelf.'), findsOneWidget);
    expect(saved, isTrue);

    final books = await service.watchBooks().first;
    expect(books.any((b) => b.title == 'New Title'), isTrue);
  });

  testWidgets('update book persists changes via injected service',
      (tester) async {
    useTallTestSurface(tester);
    final service = await createSeededBookService(
      id: 'edit-id',
      title: 'Original',
      echo: 'Old echo',
    );
    final existing = (await service.watchBooks().first).first;

    await tester.pumpWidget(
      wrapWithInkEchoNavigator(
        ReflectionPage(book: existing, bookService: service),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.enterText(_titleField, 'Revised Title');
    await tester.scrollUntilVisible(
      find.text('Save changes'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Entry updated.'), findsOneWidget);

    final updated = (await service.watchBooks().first).first;
    expect(updated.title, 'Revised Title');
  });
}
