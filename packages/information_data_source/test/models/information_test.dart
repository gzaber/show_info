import 'package:information_data_source/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Information', () {
    const text = Text(
      id: 1,
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    Information createInformation({
      int? id = 1,
      List<Text> texts = const [text],
      int color = 0xAB,
    }) {
      return Information(
        id: id,
        texts: texts,
        color: color,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => createInformation(), returnsNormally);
      });
    });

    group('equality', () {
      test('supports value equality', () {
        expect(createInformation(), equals(createInformation()));
      });

      test('props are correct', () {
        expect(
          createInformation().props,
          [
            1,
            [text],
            0xAB
          ],
        );
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createInformation().copyWith(),
          equals(createInformation()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createInformation().copyWith(
            id: null,
            texts: null,
            color: null,
          ),
          equals(createInformation()),
        );
      });

      test('replaces non null parameters', () {
        expect(
          createInformation().copyWith(
            id: 2,
            texts: [],
            color: 0xCD,
          ),
          createInformation(
            id: 2,
            texts: [],
            color: 0xCD,
          ),
        );
      });
    });
  });
}
