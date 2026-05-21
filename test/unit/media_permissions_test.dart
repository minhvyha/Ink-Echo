import 'package:flutter_test/flutter_test.dart';
import 'package:inkandecho/utils/media_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/test_helpers.dart';

void main() {
  tearDown(resetPermissionHandler);

  group('ensureCameraPermission', () {
    test('returns true when platform grants camera', () async {
      installFakePermissions(PermissionStatus.granted);
      expect(await ensureCameraPermission(), isTrue);
    });

    test('returns false when platform denies camera', () async {
      installFakePermissions(PermissionStatus.denied);
      expect(await ensureCameraPermission(), isFalse);
    });
  });

  group('ensurePhotosPermission', () {
    test('returns true when photos permission is granted', () async {
      installFakePermissions(PermissionStatus.granted);
      expect(await ensurePhotosPermission(), isTrue);
    });

    test('returns false when photos and storage are denied', () async {
      installFakePermissions(PermissionStatus.denied);
      expect(await ensurePhotosPermission(), isFalse);
    });
  });

  group('ensureMicrophonePermission', () {
    test('returns true when microphone is granted', () async {
      installFakePermissions(PermissionStatus.granted);
      expect(await ensureMicrophonePermission(), isTrue);
    });

    test('returns false when microphone is denied', () async {
      installFakePermissions(PermissionStatus.denied);
      expect(await ensureMicrophonePermission(), isFalse);
    });
  });
}
