// Compress cover photos for storage inside Firestore documents.

import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Firestore doc size limit is 1 MiB; keep base64 cover under this.
const int maxCoverBase64Length = 450000;

/// Resizes (max width 800), JPEG-compresses, returns base64 or null if too large.
Future<String?> encodeCoverImageForFirestore(Uint8List rawBytes) async {
  img.Image? decoded;
  try {
    decoded = img.decodeImage(rawBytes);
  } catch (_) {
    return null;
  }
  if (decoded == null) return null;

  var width = decoded.width > 800 ? 800 : decoded.width;
  var image = img.copyResize(decoded, width: width);
  var quality = 85;

  // Step down quality and width until under [maxCoverBase64Length].
  while (quality >= 35) {
    final jpg = Uint8List.fromList(img.encodeJpg(image, quality: quality));
    final b64 = base64Encode(jpg);
    if (b64.length <= maxCoverBase64Length) return b64;

    quality -= 12;
    if (quality < 50 && width > 320) {
      width = (width * 0.75).round();
      image = img.copyResize(image, width: width);
    }
  }

  return null;
}
