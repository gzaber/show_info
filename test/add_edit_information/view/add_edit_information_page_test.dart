import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:mocktail/mocktail.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

import '../../helpers/helpers.dart';

class MockAddEditInformationBloc
    extends MockBloc<AddEditInformationEvent, AddEditInformationState>
    implements AddEditInformationBloc {}

void main() {
  const text = source.Text(
    id: 1,
    content: 'content',
    fontSize: 20,
    isBold: false,
    isItalic: false,
    isUnderline: false,
  );
  const information = source.Information(id: 1, texts: [text], color: 0xAB);

  late AddEditInformationBloc addEditInformationBloc;

  setUp(() {
    addEditInformationBloc = MockAddEditInformationBloc();
    when(() => addEditInformationBloc.state).thenReturn(AddEditInformationState(
        initialInformation: information, texts: information.texts));
  });
  group('AddEditInformationPage', () {
    Widget buildSubject() {
      return BlocProvider.value(
        value: addEditInformationBloc,
        child: const AddEditInformationPage(),
      );
    }

    group('route', () {
      testWidgets('renders AddEditInformationPage', (tester) async {
        await tester.pumpRoute(AddEditInformationPage.route());

        expect(find.byType(AddEditInformationPage), findsOneWidget);
      });

      testWidgets('supports providing initial information', (tester) async {
        await tester
            .pumpRoute(AddEditInformationPage.route(information: information));

        expect(find.byType(AddEditInformationPage), findsOneWidget);
        expect(
          find.byWidgetPredicate((widget) =>
              widget is EditableText && widget.controller.text == 'content'),
          findsOneWidget,
        );
      });
    });

    testWidgets('pops with true when information was saved successfully',
        (tester) async {
      whenListen(
          addEditInformationBloc,
          Stream.fromIterable(const [
            AddEditInformationState(),
            AddEditInformationState(status: AddEditInformationStatus.success),
          ]));

      await tester.pumpToPop(buildSubject());

      expect(find.byType(AddEditInformationPage), findsNothing);
    });

    testWidgets('shows SnackBar with message when failure occured',
        (tester) async {
      whenListen(
          addEditInformationBloc,
          Stream.fromIterable(const [
            AddEditInformationState(),
            AddEditInformationState(status: AddEditInformationStatus.failure),
          ]));

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Something went wrong'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders AddEditInformationView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(AddEditInformationView), findsOneWidget);
    });
  });

  group('AddEditInformationView', () {
    Widget buildSubject() {
      return BlocProvider.value(
        value: addEditInformationBloc,
        child: const AddEditInformationView(),
      );
    }

    testWidgets('pops when back button is tapped', (tester) async {
      await tester.pumpToPop(buildSubject());

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditInformationView), findsNothing);
    });

    testWidgets(
        'renders AppBar with proper title text when information is being updated',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Update'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders AppBar with proper title text when information is being created',
        (tester) async {
      when(() => addEditInformationBloc.state)
          .thenReturn(const AddEditInformationState());

      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Create'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows ColorSelectionModalBottomSheet when select color button is tapped',
        (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(
          find.byKey(const Key('addEditInformationView_selectColorButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ColorSelectionModalBottomSheet), findsOneWidget);
    });

    group('save button', () {
      testWidgets('renders save icon', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byIcon(Icons.save),
          ),
          findsOneWidget,
        );
      });
      testWidgets('renders CircularProgressIndicator when status is loading',
          (tester) async {
        when(() => addEditInformationBloc.state).thenReturn(
          const AddEditInformationState(
              status: AddEditInformationStatus.loading),
        );

        await tester.pumpApp(buildSubject());

        expect(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byType(CircularProgressIndicator),
          ),
          findsOneWidget,
        );
      });

      testWidgets('adds AddEditInformationSubmitted event to bloc when tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byIcon(Icons.save));

        verify(() =>
                addEditInformationBloc.add(const AddEditInformationSubmitted()))
            .called(1);
      });
    });

    group('add text button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.descendant(
            of: find.byType(IconButton),
            matching: find.byIcon(Icons.add),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AddEditInformationNewTextAdded event to bloc when tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byIcon(Icons.add));

        verify(() => addEditInformationBloc
            .add(const AddEditInformationNewTextAdded())).called(1);
      });
    });

    group('text form field', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.descendant(
            of: find.byType(TextFormField),
            matching: find.text('content'),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AddEditInformationTextChanged to bloc when value is changed',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.enterText(find.byType(TextFormField), 'newContent');

        verify(() => addEditInformationBloc.add(
            const AddEditInformationTextChanged(
                index: 0, content: 'newContent'))).called(1);
      });
    });
    group('slidable', () {
      final finder = find.byType(Slidable);
      const offsetToRight = Offset(100, 0);
      const offsetToLeft = Offset(-100, 0);

      testWidgets('renders delete icon when slides to the right',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToRight);

        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets(
          'adds AddEditInformationTextRemoved event to bloc when delete button is tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToRight);
        await tester.tap(find.byIcon(Icons.delete));

        verify(() => addEditInformationBloc
            .add(const AddEditInformationTextRemoved(text))).called(1);
      });

      testWidgets('renders text fields icon when slides to the left',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToLeft);

        expect(find.byIcon(Icons.text_fields), findsOneWidget);
      });

      testWidgets(
          'renders TextStyleSettingsModalBottomSheet when text style button is tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToLeft);
        await tester.tap(find.byIcon(Icons.text_fields));
        await tester.pumpAndSettle();

        expect(find.byType(TextStyleSettingsModalBottomSheet), findsOneWidget);
      });
    });
  });
}
