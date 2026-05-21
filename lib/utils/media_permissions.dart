// Runtime permission checks for camera, gallery, and speech.

import 'package:permission_handler/permission_handler.dart';

/// Returns true if camera permission is granted (requests if needed).
Future<bool> ensureCameraPermission() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

/// Returns true if photos/media permission is granted (requests if needed).
Future<bool> ensurePhotosPermission() async {
  final status = await Permission.photos.request();
  if (status.isGranted) return true;
  // Android 13+ may use photos; older uses storage.
  final storage = await Permission.storage.request();
  return storage.isGranted;
}

/// Returns true if microphone permission is granted (for speech-to-text).
Future<bool> ensureMicrophonePermission() async {
  final status = await Permission.microphone.request();
  return status.isGranted;
}
