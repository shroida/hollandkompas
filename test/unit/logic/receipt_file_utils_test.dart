import 'package:flutter_test/flutter_test.dart';
import 'package:hollandkompas/features/enrollment/data/utlis/receipt_file_utils.dart';

void main() {
  group('getFileExtension', () {
    test('returns the lowercase extension for a normal filename', () {
      expect(getFileExtension('receipt.PNG'), 'png');
      expect(getFileExtension('receipt.jpg'), 'jpg');
    });

    test('handles a filename with multiple dots by using the last segment', () {
      expect(getFileExtension('my.receipt.final.webp'), 'webp');
    });

    test('falls back to jpg when there is no extension at all', () {
      expect(getFileExtension('receipt'), 'jpg');
    });

    test('falls back to jpg for an empty filename', () {
      expect(getFileExtension(''), 'jpg');
    });
  });

  group('getContentType', () {
    test('maps known image extensions to their MIME type', () {
      expect(getContentType('jpg'), 'image/jpeg');
      expect(getContentType('jpeg'), 'image/jpeg');
      expect(getContentType('png'), 'image/png');
      expect(getContentType('webp'), 'image/webp');
      expect(getContentType('gif'), 'image/gif');
    });

    test('unknown extensions fall back to a generic binary content type', () {
      expect(getContentType('pdf'), 'application/octet-stream');
      expect(getContentType(''), 'application/octet-stream');
    });
  });
}
