// Firebase Web OAuth client ID — required for Google Sign-In on Android/iOS.
// Setup steps: README → Google sign-in section.

/// Holds the Web client ID used as [GoogleSignIn] serverClientId on mobile.
abstract final class GoogleAuthConfig {
  static const String webClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: _defaultWebClientId,
  );

  static const String _defaultWebClientId =
      '654248867512-5c161t4nrgsed4io7n25uc8vaar6d9up.apps.googleusercontent.com';

  static bool get isConfigured => webClientId.trim().isNotEmpty;
}
