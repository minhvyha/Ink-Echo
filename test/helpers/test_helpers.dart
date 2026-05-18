import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';

bool _firebaseInitialized = false;

Future<void> ensureFirebaseInitialized() async {
  if (_firebaseInitialized) return;
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
  _firebaseInitialized = true;
}

void disableGoogleFontRuntimeFetching() {
  GoogleFonts.config.allowRuntimeFetching = false;
}

Widget wrapWithInkEchoTheme(Widget child) {
  return MaterialApp(
    theme: InkEchoTheme.light(highContrast: false),
    darkTheme: InkEchoTheme.dark(highContrast: false),
    home: Scaffold(body: child),
  );
}

Widget wrapWithInkEchoNavigator(Widget child) {
  return MaterialApp(
    theme: InkEchoTheme.light(highContrast: false),
    home: child,
  );
}

/// Default phone-sized surface for scrollable screens in widget tests.
void useTallTestSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Book sampleBook({
  String id = 'book-1',
  String title = 'The Left Hand of Darkness',
  String author = 'Ursula K. Le Guin',
  String echo = 'Light is the left hand of darkness.',
  String? mood = 'Deeply Moving',
  String? transcription,
  String? coverImageBase64,
  DateTime? createdAt,
}) {
  return Book(
    id: id,
    title: title,
    author: author,
    echo: echo,
    mood: mood,
    transcription: transcription,
    coverImageBase64: coverImageBase64,
    createdAt: createdAt ?? DateTime(2025, 5, 10),
  );
}

List<Book> sampleBookList() {
  return [
    sampleBook(
      id: 'b-new',
      title: 'Newest Book',
      createdAt: DateTime(2025, 5, 20),
    ),
    sampleBook(
      id: 'b-old',
      title: 'Older Book',
      author: 'Another Author',
      echo: 'An older echo',
      createdAt: DateTime(2025, 1, 3),
    ),
    sampleBook(
      id: 'b-mid',
      title: 'Alphabet Anchor',
      author: 'Zed Zebra',
      createdAt: DateTime(2025, 3, 1),
    ),
  ];
}
