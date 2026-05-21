import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/data/sample_vault_entries.dart';

void main() {
  group('sampleVaultEntries', () {
    test('defines five demo entries with required fields', () {
      expect(sampleVaultEntries.length, 5);
      for (final entry in sampleVaultEntries) {
        expect(entry.title, isNotEmpty);
        expect(entry.author, isNotEmpty);
        expect(entry.echo, isNotEmpty);
        expect(entry.imageSearchTerm, isNotEmpty);
      }
    });

    test('includes varied moods and transcription', () {
      final moods = sampleVaultEntries
          .map((e) => e.mood)
          .whereType<String>()
          .toSet();
      expect(moods.length, greaterThan(1));

      final withTranscription = sampleVaultEntries
          .where((e) => e.transcription != null && e.transcription!.isNotEmpty);
      expect(withTranscription, isNotEmpty);
    });
  });
}
