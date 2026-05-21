import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/config/google_auth_config.dart';

void main() {
  group('GoogleAuthConfig', () {
    test('webClientId is non-empty by default', () {
      expect(GoogleAuthConfig.webClientId, isNotEmpty);
      expect(GoogleAuthConfig.webClientId, contains('.apps.googleusercontent.com'));
    });

    test('isConfigured is true when client id is set', () {
      expect(GoogleAuthConfig.isConfigured, isTrue);
    });
  });
}
