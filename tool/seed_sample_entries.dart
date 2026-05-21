import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:inkandecho/data/sample_vault_entries.dart';
import 'package:inkandecho/firebase_options.dart';
import 'package:inkandecho/services/book_service.dart';

const _defaultEmail = 'test@gmail.com';
const _defaultPassword = 'Test1234';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final email = const String.fromEnvironment('SEED_EMAIL', defaultValue: _defaultEmail);
  final password =
      const String.fromEnvironment('SEED_PASSWORD', defaultValue: _defaultPassword);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  stdout.writeln('Signing in as $email …');
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    stderr.writeln('Sign-in failed. Check credentials in README or pass --dart-define.');
    exit(1);
  }

  final booksRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('books');

  final existing = await booksRef.get();
  if (existing.docs.isNotEmpty) {
    stdout.writeln(
      'Vault already has ${existing.docs.length} entries. Skipping seed (delete them first to re-run).',
    );
    exit(0);
  }

  stdout.writeln('Seeding ${sampleVaultEntries.length} entries …');

  for (final sample in sampleVaultEntries) {
    await BookService.instance.saveBook(
      title: sample.title,
      author: sample.author,
      echo: sample.echo,
      mood: sample.mood,
      transcription: sample.transcription,
    );
    stdout.writeln('  ✓ ${sample.title}');
  }

  final count = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('books')
      .get()
      .then((s) => s.docs.length);

  stdout.writeln('Done. Vault now has $count book(s) for this account.');
  stdout.writeln('Add cover photos using the search terms in docs/sample_vault_entries.md');
  exit(0);
}
