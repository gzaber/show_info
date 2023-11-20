import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:mocktail/mocktail.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

import '../../helpers/helpers.dart';

class MockAddEditInformationBloc
    extends MockBloc<AddEditInformationEvent, AddEditInformationState>
    implements AddEditInformationBloc {}

void main() {
  group('TextStyleSettingsModalBottomSheet', () {
    late AddEditInformationBloc addEditInformationBloc;
    const source.Text text = source.Text(
      id: 1,
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );

    setUp(() {
      addEditInformationBloc = MockAddEditInformationBloc();
    });

    Widget buildSubject() {
      return TextStyleSettingsModalBottomSheet(
        bloc: addEditInformationBloc,
        text: text,
        textIndex: 0,
      );
    }

    testWidgets('is rendered when show method is invoked', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                TextStyleSettingsModalBottomSheet.show(
                  context: context,
                  bloc: addEditInformationBloc,
                  text: text,
                  textIndex: 0,
                );
              },
              icon: const Icon(Icons.add),
            );
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(TextStyleSettingsModalBottomSheet), findsOneWidget);
    });

    testWidgets('pops when check button is tapped', (tester) async {
      await tester.pumpToPop(buildSubject());

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.byType(TextStyleSettingsModalBottomSheet), findsNothing);
    });

    testWidgets(
        'adds AddEditInformationTextChanged event to bloc '
        'when decrease font size button is tapped', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.text_decrease));

      verify(() => addEditInformationBloc
              .add(const AddEditInformationTextChanged(index: 0, fontSize: 19)))
          .called(1);
    });

    testWidgets(
        'adds AddEditInformationTextChanged event to bloc '
        'when increase font size button is tapped', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.text_increase));

      verify(() => addEditInformationBloc
              .add(const AddEditInformationTextChanged(index: 0, fontSize: 21)))
          .called(1);
    });

    testWidgets(
        'adds AddEditInformationTextChanged event to bloc '
        'when bold button is tapped', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.format_bold));

      verify(() => addEditInformationBloc
              .add(const AddEditInformationTextChanged(index: 0, isBold: true)))
          .called(1);
    });

    testWidgets(
        'adds AddEditInformationTextChanged event to bloc '
        'when italic button is tapped', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.format_italic));

      verify(() => addEditInformationBloc.add(
              const AddEditInformationTextChanged(index: 0, isItalic: true)))
          .called(1);
    });

    testWidgets(
        'adds AddEditInformationTextChanged event to bloc '
        'when underline button is tapped', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.format_underline));

      verify(() => addEditInformationBloc.add(
              const AddEditInformationTextChanged(index: 0, isUnderline: true)))
          .called(1);
    });
  });
}
