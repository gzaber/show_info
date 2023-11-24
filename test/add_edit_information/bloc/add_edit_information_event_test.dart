import 'package:flutter_test/flutter_test.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

void main() {
  group('AddEditInformationEvent', () {
    group('AddEditInformationColorChanged', () {
      test('supports value equality', () {
        expect(
          const AddEditInformationColorChanged(0xAB),
          equals(const AddEditInformationColorChanged(0xAB)),
        );
      });

      test('props are correct', () {
        expect(
          const AddEditInformationColorChanged(0xAB).props,
          equals([0xAB]),
        );
      });
    });

    group('AddEditInformationNewTextAdded', () {
      test('supports value equality', () {
        expect(
          const AddEditInformationNewTextAdded(),
          equals(const AddEditInformationNewTextAdded()),
        );
      });

      test('props are correct', () {
        expect(
          const AddEditInformationNewTextAdded().props,
          equals([]),
        );
      });
    });

    group('AddEditInformationTextRemoved', () {
      test('supports value equality', () {
        expect(
          const AddEditInformationTextRemoved(1),
          equals(const AddEditInformationTextRemoved(1)),
        );
      });

      test('props are correct', () {
        expect(
          const AddEditInformationTextRemoved(1).props,
          equals([1]),
        );
      });
    });

    group('AddEditInformationTextChanged', () {
      test('supports value equality', () {
        expect(
          const AddEditInformationTextChanged(index: 1),
          equals(const AddEditInformationTextChanged(index: 1)),
        );
      });

      test('props are correct', () {
        expect(
          const AddEditInformationTextChanged(
            index: 1,
            content: 'content',
            fontSize: 20,
            isBold: false,
            isItalic: false,
            isUnderline: false,
          ).props,
          equals([1, 'content', 20, false, false, false]),
        );
      });
    });

    group('AddEditInformationSubmitted', () {
      test('supports value equality', () {
        expect(
          const AddEditInformationSubmitted(),
          equals(const AddEditInformationSubmitted()),
        );
      });

      test('props are correct', () {
        expect(
          const AddEditInformationSubmitted().props,
          equals([]),
        );
      });
    });
  });
}
