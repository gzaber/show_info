import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:show_information/information_list/information_list.dart';

void main() {
  group('InformationListEvent', () {
    const text = Text(
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    const information = Information(id: 1, texts: [text], color: 0xAB);
    group('InformationListSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          const InformationListSubscriptionRequested(),
          equals(const InformationListSubscriptionRequested()),
        );
      });

      test('props are correct', () {
        expect(
          const InformationListSubscriptionRequested().props,
          equals([]),
        );
      });
    });

    group('InformationListInformationDeleted', () {
      test('supports value equality', () {
        expect(
          const InformationListInformationDeleted(information),
          equals(const InformationListInformationDeleted(information)),
        );
      });

      test('props are correct', () {
        expect(
          const InformationListInformationDeleted(information).props,
          equals([information]),
        );
      });
    });
  });
}
