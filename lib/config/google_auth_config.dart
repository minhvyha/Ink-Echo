/// Google Sign-In OAuth client IDs for Firebase Auth.
///
/// **Android (required):** paste your Firebase **Web** client ID below.
/// Find it in [Firebase Console](https://console.firebase.google.com/) →
/// Project settings → Your apps → **Web** app → *Web client ID*,
/// or Authentication → Sign-in method → Google → *Web SDK configuration*.
///
/// Format: `654248867512-xxxxxxxx.apps.googleusercontent.com`
///
/// Also required for the emulator:
/// 1. Authentication → Sign-in method → enable **Google**.
/// 2. Project settings → Android app → add **SHA-1** debug fingerprint
///    (`keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android`)
/// 3. Re-download `android/app/google-services.json` and replace the old file.
///
/// Override at build time: `--dart-define=GOOGLE_WEB_CLIENT_ID=your-id.apps.googleusercontent.com`
abstract final class GoogleAuthConfig {
  static const String webClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: _defaultWebClientId,
  );

  /// Paste your Web client ID here after enabling Google in Firebase.
  static const String _defaultWebClientId = '654248867512-5c161t4nrgsed4io7n25uc8vaar6d9up.apps.googleusercontent.com';

  static bool get isConfigured => webClientId.trim().isNotEmpty;
}
