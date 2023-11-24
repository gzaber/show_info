import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';
import 'package:show_information/information_list/information_list.dart';
import 'package:show_information/information_preview/information_preview.dart';

import '../../helpers/helpers.dart';

class MockInformationRepository extends Mock implements InformationRepository {}

class MockInformationListBloc
    extends MockBloc<InformationListEvent, InformationListState>
    implements InformationListBloc {}

class FakeInformation extends Fake implements source.Information {}

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

  late InformationRepository informationRepository;

  setUpAll(() {
    registerFallbackValue(FakeInformation());
  });

  setUp(() {
    informationRepository = MockInformationRepository();
    when(() => informationRepository.readAllInformation())
        .thenAnswer((_) => const Stream.empty());
  });

  group('InformationListPage', () {
    testWidgets(
        'subscribes to information stream from repository on initialization',
        (tester) async {
      await tester.pumpApp(
        const InformationListPage(),
        informationRepository: informationRepository,
      );

      verify(() => informationRepository.readAllInformation()).called(1);
    });

    testWidgets('renders InformationListView', (tester) async {
      await tester.pumpApp(
        const InformationListPage(),
        informationRepository: informationRepository,
      );

      expect(find.byType(InformationListView), findsOneWidget);
    });
  });

  group('InformationListView', () {
    late InformationListBloc informationListBloc;

    setUp(() {
      informationListBloc = MockInformationListBloc();
      when(() => informationListBloc.state).thenReturn(
        const InformationListState(
          status: InformationListStatus.success,
          informationList: [information],
        ),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: informationListBloc,
        child: const InformationListView(),
      );
    }

    testWidgets('renders AppBar with proper title text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(l10n.informationListAppBarTitle),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator when status is loading',
        (tester) async {
      when(() => informationListBloc.state).thenReturn(
          const InformationListState(status: InformationListStatus.loading));

      await tester.pumpApp(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows SnackBar with message when status is failure',
        (tester) async {
      whenListen(
          informationListBloc,
          Stream.fromIterable(const [
            InformationListState(),
            InformationListState(status: InformationListStatus.failure),
          ]));

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(l10n.errorMessage),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders text message when information list is empty',
        (tester) async {
      when(() => informationListBloc.state).thenReturn(
        const InformationListState(informationList: []),
      );

      await tester.pumpApp(buildSubject());

      expect(
        find.text(l10n.informationListEmptyList),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders list items with text when information list is not empty',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text(text.content), findsOneWidget);
    });

    testWidgets(
        'renders Divider as separator when there is more than one list item',
        (tester) async {
      when(() => informationListBloc.state).thenReturn(
        const InformationListState(
          status: InformationListStatus.success,
          informationList: [information, information],
        ),
      );

      await tester.pumpApp(buildSubject());

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets(
        'navigates to InformationPreviewPage when information list item is tapped',
        (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.text(text.content));
      await tester.pumpAndSettle();

      expect(find.byType(InformationPreviewPage), findsOneWidget);
    });

    group('fab', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(FloatingActionButton), findsOneWidget);
      });

      testWidgets('navigates to AddEditInformationPage when tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.byType(AddEditInformationPage), findsOneWidget);
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
          'shows AlertDialog with confirmation question when delete button is tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToRight);
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text(l10n.informationListDeleteDialogContent),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds InformationListInformationDeleted event to bloc '
          'when pops with true from dialog', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToRight);
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();
        await tester
            .tap(find.text(l10n.informationListDeleteDialogApproveButtonText));

        verify(() => informationListBloc.add(
            const InformationListInformationDeleted(information))).called(1);
      });

      testWidgets(
          'does not add InformationListInformationDeleted event to bloc '
          'when pops with false from dialog', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToRight);
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();
        await tester
            .tap(find.text(l10n.informationListDeleteDialogCancelButtonText));

        verifyNever(() => informationListBloc
            .add(const InformationListInformationDeleted(information)));
      });

      testWidgets('renders edit icon when slides to the left', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToLeft);

        expect(find.byIcon(Icons.edit), findsOneWidget);
      });

      testWidgets(
          'navigates to AddEditInformationPage when edit button is tapped',
          (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.dragSlidable(finder, offsetToLeft);
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        expect(find.byType(AddEditInformationPage), findsOneWidget);
      });

      testWidgets(
          'subscribes again to information stream from repository '
          'when pops from AddEditInformationPage with true', (tester) async {
        when(() => informationRepository.saveInformation(any()))
            .thenAnswer((_) async {});
        when(() => informationRepository.saveManyTexts(any()))
            .thenAnswer((_) async {});

        await tester.pumpApp(
          buildSubject(),
          informationRepository: informationRepository,
        );

        await tester.dragSlidable(finder, offsetToLeft);
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.save));
        await tester.pumpAndSettle();

        verify(() => informationListBloc
            .add(const InformationListSubscriptionRequested())).called(1);
      });
    });
  });
}
