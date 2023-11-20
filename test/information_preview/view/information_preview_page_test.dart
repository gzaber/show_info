import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:mockingjay/mockingjay.dart';
import 'package:show_information/information_preview/information_preview.dart';

import '../../helpers/helpers.dart';

void main() {
  group('InformationPreviewPage', () {
    const text1 = source.Text(
      id: 1,
      content: 'content1',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    final text2 = text1.copyWith(id: 2, content: 'content2');
    final information =
        source.Information(id: 1, texts: [text1, text2], color: 0xAB);

    late MockNavigator navigator;

    setUp(() {
      navigator = MockNavigator();
    });

    Widget buildSubject() {
      return InformationPreviewPage(information: information);
    }

    group('route', () {
      testWidgets('renders InformationPreviewPage', (tester) async {
        await tester.pumpRoute(
          InformationPreviewPage.route(information: information),
        );

        expect(find.byType(InformationPreviewPage), findsOneWidget);
      });
    });

    testWidgets('pops when back button is tapped', (tester) async {
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: buildSubject(),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back_ios));

      verify(() => navigator.pop()).called(1);
    });

    testWidgets('renders information texts', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('content1'), findsOneWidget);
      expect(find.text('content2'), findsOneWidget);
    });
  });
}
