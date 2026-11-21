import 'package:espflutter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteSite.fromSharedText', () {
    test('creates a favorite from a shared URL', () {
      final site = FavoriteSite.fromSharedText('https://example.com/page');

      expect(site?.name, 'example.com');
      expect(site?.url, 'https://example.com/page');
    });

    test('extracts a URL from shared text and trims trailing punctuation', () {
      final site = FavoriteSite.fromSharedText(
        'Cek situs ini: https://example.com/path.',
      );

      expect(site?.url, 'https://example.com/path');
    });

    test('rejects non-HTTP URLs and text without a URL', () {
      expect(FavoriteSite.fromSharedText('mailto:user@example.com'), isNull);
      expect(FavoriteSite.fromSharedText('teks biasa'), isNull);
    });
  });
}
