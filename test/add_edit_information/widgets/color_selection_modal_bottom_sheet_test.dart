import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

import '../../helpers/helpers.dart';

class MockAddEditInformationBloc
    extends MockBloc<AddEditInformationEvent, AddEditInformationState>
    implements AddEditInformationBloc {}

void main() {
  group('ColorSelectionModalBottomSheet', () {
    late AddEditInformationBloc addEditInformationBloc;
    final colors = [Colors.red.value, Colors.green.value, Colors.blue.value];

    setUp(() {
      addEditInformationBloc = MockAddEditInformationBloc();
    });

    Widget buildSubject() {
      return ColorSelectionModalBottomSheet(
        colors: colors,
        bloc: addEditInformationBloc,
      );
    }

    testWidgets('is rendered when show method is invoked', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                ColorSelectionModalBottomSheet.show(
                  context: context,
                  colors: colors,
                  bloc: addEditInformationBloc,
                );
              },
              icon: const Icon(Icons.add),
            );
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(ColorSelectionModalBottomSheet), findsOneWidget);
    });

    testWidgets('pops when color button is tapped', (tester) async {
      await tester.pumpToPop(buildSubject());

      await tester
          .tap(find.byKey(const Key('colorSelectionModalBottomSheet_color0')));
      await tester.pumpAndSettle();

      expect(find.byType(ColorSelectionModalBottomSheet), findsNothing);
    });

    testWidgets(
        'adds AddEditInformationColorChanged event to bloc when color button is tapped',
        (tester) async {
      await tester.pumpToPop(buildSubject());

      await tester
          .tap(find.byKey(const Key('colorSelectionModalBottomSheet_color0')));

      verify(() => addEditInformationBloc
          .add(AddEditInformationColorChanged(colors[0]))).called(1);
    });
  });
}
