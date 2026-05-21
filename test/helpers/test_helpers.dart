import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkandecho/models/book.dart';
import 'package:inkandecho/services/book_service.dart';
import 'package:inkandecho/theme/ink_echo_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

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

void useTallTestSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Bounded settle — avoids [pumpAndSettle] hanging on speech/animation timers.
Future<void> pumpBrief(WidgetTester tester, [Duration duration = const Duration(milliseconds: 400)]) async {
  await tester.pump();
  await tester.pump(duration);
}

/// Scrolls until [finder] is visible (generous limit for long reflection forms).
Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
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

const testUserId = 'user-123';

FakeFirebaseFirestore? _activeTestFirestore;

/// Firestore + auth wired for widget tests that need real CRUD without Firebase.
BookService createTestBookService({FakeFirebaseFirestore? firestore}) {
  _activeTestFirestore = firestore ?? FakeFirebaseFirestore();
  return BookService.forTesting(
    firestore: _activeTestFirestore!,
    auth: MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: testUserId, email: 'reader@test.com'),
    ),
  );
}

/// Reads books directly from fake Firestore (avoids stream hangs in widget tests).
Future<List<Map<String, dynamic>>> readTestBookDocs() async {
  final firestore = _activeTestFirestore;
  if (firestore == null) return [];
  final snap = await firestore
      .collection('users')
      .doc(testUserId)
      .collection('books')
      .get();
  return snap.docs.map((d) => d.data()).toList();
}

Future<Map<String, dynamic>?> readTestBookDoc(String id) async {
  final firestore = _activeTestFirestore;
  if (firestore == null) return null;
  final doc = await firestore
      .collection('users')
      .doc(testUserId)
      .collection('books')
      .doc(id)
      .get();
  return doc.data();
}

/// Writes one book document with a stable id for widget tests.
Future<void> seedTestBook(
  FakeFirebaseFirestore firestore, {
  required String id,
  required String title,
  String author = 'Author',
  String echo = 'Echo',
  DateTime? createdAt,
}) async {
  await firestore.collection('users').doc(testUserId).collection('books').doc(id).set({
    'title': title,
    'author': author,
    'echo': echo,
    'createdAt': Timestamp.fromDate(createdAt ?? DateTime(2025, 5, 20)),
  });
}

Future<BookService> createSeededBookService({
  required String id,
  required String title,
  String author = 'Author',
  String echo = 'Echo',
}) async {
  final firestore = FakeFirebaseFirestore();
  _activeTestFirestore = firestore;
  await seedTestBook(
    firestore,
    id: id,
    title: title,
    author: author,
    echo: echo,
  );
  return createTestBookService(firestore: firestore);
}

/// Stubs [Permission.request] results for camera, photos, and microphone tests.
class FakePermissionHandler extends PermissionHandlerPlatform {
  FakePermissionHandler(this._status);

  final PermissionStatus _status;

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    return {for (final p in permissions) p: _status};
  }
}

PermissionHandlerPlatform? _savedPermissionHandler;

void installFakePermissions(PermissionStatus status) {
  _savedPermissionHandler ??= PermissionHandlerPlatform.instance;
  PermissionHandlerPlatform.instance = FakePermissionHandler(status);
}

void resetPermissionHandler() {
  final saved = _savedPermissionHandler;
  if (saved != null) {
    PermissionHandlerPlatform.instance = saved;
    _savedPermissionHandler = null;
  }
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
