import 'package:information_data_source/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Text', () {
    Text createText({
      int? id = 1,
      String content = 'content',
      int fontSize = 20,
      bool isBold = false,
      bool isItalic = false,
      bool isUnderline = false,
    }) {
      return Text(
        id: id,
        content: content,
        fontSize: fontSize,
        isBold: isBold,
        isItalic: isItalic,
        isUnderline: isUnderline,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => createText(), returnsNormally);
      });
    });

    group('equality', () {
      test('supports value equality', () {
        expect(createText(), equals(createText()));
      });

      test('props are correct', () {
        expect(
          createText().props,
          equals([1, 'content', 20, false, false, false]),
        );
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createText().copyWith(),
          equals(createText()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createText().copyWith(
            id: null,
            content: null,
            fontSize: null,
            isBold: null,
            isItalic: null,
            isUnderline: null,
          ),
          equals(createText()),
        );
      });

      test('replaces non null parameters', () {
        expect(
          createText().copyWith(
            id: 2,
            content: 'some text',
            fontSize: 22,
            isBold: true,
            isItalic: true,
            isUnderline: true,
          ),
          equals(
            createText(
              id: 2,
              content: 'some text',
              fontSize: 22,
              isBold: true,
              isItalic: true,
              isUnderline: true,
            ),
          ),
        );
      });
    });
  });
}
