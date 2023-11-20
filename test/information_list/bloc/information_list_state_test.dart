import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:show_information/information_list/information_list.dart';

void main() {
  group('InformationListState', () {
    const text = Text(
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    const information = Information(id: 1, texts: [text], color: 0xAB);

    InformationListState createState({
      InformationListStatus status = InformationListStatus.initial,
      List<Information> informationList = const [],
    }) {
      return InformationListState(
          status: status, informationList: informationList);
    }

    test('supports value equality', () {
      expect(
        createState(),
        equals(createState()),
      );
    });

    test('props are correct', () {
      expect(
        createState(informationList: [information]).props,
        equals([
          InformationListStatus.initial,
          [information]
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
            informationList: null,
          ),
          equals(createState()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createState().copyWith(
            status: InformationListStatus.success,
            informationList: [information],
          ),
          equals(
            createState(
              status: InformationListStatus.success,
              informationList: [information],
            ),
          ),
        );
      });
    });
  });
}
