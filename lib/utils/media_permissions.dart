import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> ensureCameraPermission() async {
  if (kIsWeb) return true;
  return _ensure(Permission.camera);
}

Future<bool> ensurePhotosPermission() async {
  if (kIsWeb) return true;
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _ensure(Permission.photos);
  }
  return _ensure(Permission.photos);
}

Future<bool> ensureMicrophonePermission() async {
  if (kIsWeb) return true;
  return _ensure(Permission.microphone);
}

Future<bool> _ensure(Permission permission) async {
  var status = await permission.status;
  if (status.isGranted) return true;
  status = await permission.request();
  return status.isGranted;
}
