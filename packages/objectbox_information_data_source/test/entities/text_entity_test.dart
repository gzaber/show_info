import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox_information_data_source/src/entities/entities.dart';

void main() {
  group('TextEntity', () {
    TextEntity createTextEntity({
      int id = 1,
      String content = 'content',
      int fontSize = 20,
      bool isBold = false,
      bool isItalic = false,
      bool isUnderline = false,
    }) =>
        TextEntity(
          id: id,
          content: content,
          fontSize: fontSize,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
        );

    Text createTextModel({
      int? id = 1,
      String content = 'content',
      int fontSize = 20,
      bool isBold = false,
      bool isItalic = false,
      bool isUnderline = false,
    }) =>
        Text(
          id: id,
          content: content,
          fontSize: fontSize,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
        );

    group('constructor', () {
      test('works properly', () {
        expect(() => createTextEntity(), returnsNormally);
      });
    });

    group('fromModel', () {
      test('returns TextEntity created from Text model', () {
        expect(
          TextEntity.fromModel(createTextModel()),
          equals(createTextEntity()),
        );
      });

      test('returns TextEntity with id equals to 0 when model id is null', () {
        expect(
          TextEntity.fromModel(createTextModel(id: null)),
          equals(createTextEntity(id: 0)),
        );
      });
    });

    group('toModel', () {
      test('returns Text model created from TextEntity', () {
        expect(
          createTextEntity().toModel(),
          equals(createTextModel()),
        );
      });
    });
  });
}
