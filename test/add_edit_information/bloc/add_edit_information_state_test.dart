import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

void main() {
  group('AddEditInformationState', () {
    const text = Text(
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    const information = Information(id: 1, texts: [text], color: 0xAB);

    AddEditInformationState createState({
      AddEditInformationStatus status = AddEditInformationStatus.initial,
      Information? initialInformation,
      List<Text> texts = const [],
      List<Text> textsToDelete = const [],
      int color = 0xCD,
    }) {
      return AddEditInformationState(
        status: status,
        initialInformation: initialInformation,
        texts: texts,
        textsToDelete: textsToDelete,
        color: color,
      );
    }

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState(
            initialInformation: information,
            texts: [text],
            textsToDelete: [text]).props,
        equals([
          AddEditInformationStatus.initial,
          information,
          [text],
          [text],
          0xCD
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState().copyWith(
            status: null,
            initialInformation: null,
            texts: null,
            textsToDelete: null,
            color: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            status: AddEditInformationStatus.success,
            initialInformation: information,
            texts: [text],
            textsToDelete: [text],
            color: 0xEF,
          ),
          equals(
            createState(
              status: AddEditInformationStatus.success,
              initialInformation: information,
              texts: [text],
              textsToDelete: [text],
              color: 0xEF,
            ),
          ),
        );
      });
    });
  });
}
