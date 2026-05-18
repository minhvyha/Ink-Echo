import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:inkandecho/utils/image_base64_encoder.dart';

Uint8List _tinyJpegBytes({int width = 40, int height = 40}) {
  final image = img.Image(width: width, height: height);
  img.fill(image, color: img.ColorRgb8(120, 80, 200));
  return Uint8List.fromList(img.encodeJpg(image, quality: 90));
}

void main() {
  group('encodeCoverImageForFirestore', () {
    test('encodes a small image to base64 under the size cap', () async {
      final result = await encodeCoverImageForFirestore(_tinyJpegBytes());

      expect(result, isNotNull);
      expect(result!.length, lessThan(maxCoverBase64Length));
      expect(result, isNotEmpty);
    });

    test('returns null for invalid image bytes', () async {
      final result = await encodeCoverImageForFirestore(Uint8List.fromList([1, 2, 3]));
      expect(result, isNull);
    });
  });
}
