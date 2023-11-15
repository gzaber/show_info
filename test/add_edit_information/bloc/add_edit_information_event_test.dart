import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:show_information/add_edit_information/bloc/add_edit_information_bloc.dart';

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
      const text = Text(
        content: 'content',
        fontSize: 20,
        isBold: false,
        isItalic: false,
        isUnderline: false,
      );

      test('supports value equality', () {
        expect(
          const AddEditInformationTextRemoved(text),
          equals(const AddEditInformationTextRemoved(text)),
        );
      });

      test('props are correct', () {
        expect(
          const AddEditInformationTextRemoved(text).props,
          equals([text]),
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
