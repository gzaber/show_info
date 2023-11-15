import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:show_information/add_edit_information/bloc/add_edit_information_bloc.dart';

class MockInformationRepository extends Mock implements InformationRepository {}

class FakeInformation extends Fake implements Information {}

void main() {
  group('AddEditInformationBloc', () {
    late InformationRepository informationRepository;

    const text = Text(
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    const information = Information(texts: [text], color: 0xAB);

    setUpAll(() {
      registerFallbackValue(FakeInformation());
    });

    setUp(() {
      informationRepository = MockInformationRepository();
    });

    AddEditInformationBloc buildBloc() {
      return AddEditInformationBloc(
        informationRepository: informationRepository,
        initialInformation: null,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const AddEditInformationState()),
        );
      });

      test('has correct state when initial information is provided', () {
        final bloc = AddEditInformationBloc(
          informationRepository: informationRepository,
          initialInformation:
              information.copyWith(id: 1, texts: [text.copyWith(id: 1)]),
        );

        expect(bloc.state.texts, [text.copyWith(id: 1)]);
        expect(bloc.state.color, information.color);
      });
    });

    group('AddEditInformationColorChanged', () {
      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with updated color',
        build: buildBloc,
        act: (bloc) => bloc.add(const AddEditInformationColorChanged(0xAB)),
        expect: () => const [AddEditInformationState(color: 0xAB)],
      );
    });

    group('AddEditInformationNewTextAdded', () {
      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with new text added to list of texts',
        build: buildBloc,
        act: (bloc) => bloc.add(const AddEditInformationNewTextAdded()),
        expect: () => const [
          AddEditInformationState(
            texts: [
              Text(
                content: '',
                fontSize: 16,
                isBold: false,
                isItalic: false,
                isUnderline: false,
              )
            ],
          )
        ],
      );
    });

    group('AddEditInformationTextRemoved', () {
      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with text removed from list of texts '
        'and added to list of texts to delete',
        build: buildBloc,
        seed: () => const AddEditInformationState(texts: [text]),
        act: (bloc) => bloc.add(const AddEditInformationTextRemoved(text)),
        expect: () => const [
          AddEditInformationState(texts: [], textsToDelete: [text]),
        ],
      );
    });

    group('AddEditInformationTextChanged', () {
      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with updated text',
        build: buildBloc,
        seed: () => const AddEditInformationState(texts: [text]),
        act: (bloc) => bloc.add(
          const AddEditInformationTextChanged(
            index: 0,
            content: 'some content',
            fontSize: 22,
            isBold: true,
            isItalic: true,
            isUnderline: true,
          ),
        ),
        expect: () => const [
          AddEditInformationState(texts: [
            Text(
              id: null,
              content: 'some content',
              fontSize: 22,
              isBold: true,
              isItalic: true,
              isUnderline: true,
            )
          ])
        ],
      );
    });

    group('AddEditInformationSubmitted', () {
      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with success status when new information saved successfully',
        setUp: () {
          when(() => informationRepository.saveInformation(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => const AddEditInformationState(texts: [text]),
        act: (bloc) => bloc.add(const AddEditInformationSubmitted()),
        expect: () => const [
          AddEditInformationState(
            status: AddEditInformationStatus.loading,
            texts: [text],
          ),
          AddEditInformationState(
            status: AddEditInformationStatus.success,
            texts: [text],
          ),
        ],
        verify: (bloc) {
          verify(() => informationRepository.saveInformation(
                Information(
                  texts: const [text],
                  color: const AddEditInformationState().color,
                ),
              )).called(1);
        },
      );

      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with success status when updated initial information saved successfully',
        setUp: () {
          when(() => informationRepository.saveInformation(any()))
              .thenAnswer((_) async {});
          when(() => informationRepository.saveManyTexts(any()))
              .thenAnswer((_) async {});
          when(() => informationRepository.deleteManyTexts(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => AddEditInformationState(
          initialInformation: information.copyWith(
            id: 1,
            texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
          ),
          texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
          textsToDelete: [text.copyWith(id: 3), text.copyWith(id: 4)],
        ),
        act: (bloc) => bloc.add(const AddEditInformationSubmitted()),
        expect: () => [
          AddEditInformationState(
            status: AddEditInformationStatus.loading,
            initialInformation: information.copyWith(
              id: 1,
              texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
            ),
            texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
            textsToDelete: [text.copyWith(id: 3), text.copyWith(id: 4)],
          ),
          AddEditInformationState(
            status: AddEditInformationStatus.success,
            initialInformation: information.copyWith(
              id: 1,
              texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
            ),
            texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
            textsToDelete: [text.copyWith(id: 3), text.copyWith(id: 4)],
          ),
        ],
        verify: (bloc) {
          verify(() => informationRepository.saveInformation(
              information.copyWith(
                  id: 1,
                  texts: [text.copyWith(id: 1), text.copyWith(id: 2)],
                  color: const AddEditInformationState().color))).called(1);
          verify(() => informationRepository
                  .saveManyTexts([text.copyWith(id: 1), text.copyWith(id: 2)]))
              .called(1);
          verify(() => informationRepository.deleteManyTexts([3, 4])).called(1);
        },
      );

      blocTest<AddEditInformationBloc, AddEditInformationState>(
        'emits new state with failure status when save to repository fails',
        setUp: () {
          when(() => informationRepository.saveInformation(any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        seed: () => const AddEditInformationState(texts: [text]),
        act: (bloc) => bloc.add(const AddEditInformationSubmitted()),
        expect: () => const [
          AddEditInformationState(
            status: AddEditInformationStatus.loading,
            texts: [text],
          ),
          AddEditInformationState(
            status: AddEditInformationStatus.failure,
            texts: [text],
          ),
        ],
        verify: (bloc) {
          verify(() => informationRepository.saveInformation(
                Information(
                  texts: const [text],
                  color: const AddEditInformationState().color,
                ),
              )).called(1);
        },
      );
    });
  });
}
