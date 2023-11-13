import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox_information_data_source/src/entities/entities.dart';

void main() {
  group('InformationEntity', () {
    final textEntity = TextEntity(
      id: 1,
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );

    InformationEntity createInformationEntity() {
      return InformationEntity(id: 1, texts: [textEntity], color: 0xAE);
    }

    Information createInformationModel() {
      return Information(id: 1, texts: [textEntity.toModel()], color: 0xAE);
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => createInformationEntity(), returnsNormally);
      });
    });

    group('equality', () {
      test('supports value equality', () {
        expect(createInformationEntity(), equals(createInformationEntity()));
      });

      test('props are corrects', () {
        expect(
          createInformationEntity().props,
          equals([
            1,
            [textEntity],
            0xAE
          ]),
        );
      });
    });

    group('fromModel', () {
      test('returns InformationEntity created from Information model', () {
        expect(
          InformationEntity.fromModel(createInformationModel()),
          equals(createInformationEntity()),
        );
      });
    });

    group('toModel', () {
      test('returns Information model created from InformationEntity', () {
        expect(
          createInformationEntity().toModel(),
          equals(createInformationModel()),
        );
      });
    });
  });
}
