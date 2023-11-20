import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:show_information/information_list/information_list.dart';

class MockInformationRepository extends Mock implements InformationRepository {}

void main() {
  group('InformationListBloc', () {
    late InformationRepository informationRepository;

    const text = Text(
      id: 1,
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );
    const information = Information(id: 1, texts: [text], color: 0xAB);

    setUp(() {
      informationRepository = MockInformationRepository();
    });

    InformationListBloc buildBloc() {
      return InformationListBloc(informationRepository: informationRepository);
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const InformationListState()),
        );
      });
    });

    group('InformationListSubscriptionRequested', () {
      blocTest<InformationListBloc, InformationListState>(
        'emits state with success status and updated list of information '
        'when repository stream emits new information',
        setUp: () {
          when(() => informationRepository.readAllInformation())
              .thenAnswer((_) => Stream.value([information]));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const InformationListSubscriptionRequested()),
        expect: () => const [
          InformationListState(status: InformationListStatus.loading),
          InformationListState(
            status: InformationListStatus.success,
            informationList: [information],
          ),
        ],
        verify: (_) {
          verify(() => informationRepository.readAllInformation()).called(1);
        },
      );

      blocTest<InformationListBloc, InformationListState>(
        'emits state with failure status when repository stream emits error',
        setUp: () {
          when(() => informationRepository.readAllInformation())
              .thenAnswer((_) => Stream.error(Exception()));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const InformationListSubscriptionRequested()),
        expect: () => const [
          InformationListState(status: InformationListStatus.loading),
          InformationListState(status: InformationListStatus.failure),
        ],
        verify: (_) {
          verify(() => informationRepository.readAllInformation()).called(1);
        },
      );
    });

    group('InformationListInformationDeleted', () {
      blocTest<InformationListBloc, InformationListState>(
        'emits state with success status when information deleted successfully',
        setUp: () {
          when(() => informationRepository.deleteInformation(any()))
              .thenAnswer((_) async {});
          when(() => informationRepository.deleteManyTexts(any()))
              .thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => const InformationListState(informationList: [information]),
        act: (bloc) =>
            bloc.add(const InformationListInformationDeleted(information)),
        expect: () => const [
          InformationListState(
            status: InformationListStatus.loading,
            informationList: [information],
          ),
          InformationListState(
            status: InformationListStatus.success,
            informationList: [information],
          ),
        ],
        verify: (_) {
          verify(() => informationRepository.deleteInformation(information.id!))
              .called(1);
          verify(() => informationRepository.deleteManyTexts([information.id!]))
              .called(1);
        },
      );

      blocTest<InformationListBloc, InformationListState>(
        'emits state with failure status when error occured during information deletion',
        setUp: () {
          when(() => informationRepository.deleteInformation(any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        seed: () => const InformationListState(informationList: [information]),
        act: (bloc) =>
            bloc.add(const InformationListInformationDeleted(information)),
        expect: () => const [
          InformationListState(
            status: InformationListStatus.loading,
            informationList: [information],
          ),
          InformationListState(
            status: InformationListStatus.failure,
            informationList: [information],
          ),
        ],
        verify: (_) {
          verify(() => informationRepository.deleteInformation(information.id!))
              .called(1);
          verifyNever(
              () => informationRepository.deleteManyTexts([information.id!]));
        },
      );

      blocTest<InformationListBloc, InformationListState>(
        'emits state with failure status when error occured during texts deletion',
        setUp: () {
          when(() => informationRepository.deleteInformation(any()))
              .thenAnswer((_) async {});
          when(() => informationRepository.deleteManyTexts(any()))
              .thenThrow(Exception());
        },
        build: buildBloc,
        seed: () => const InformationListState(informationList: [information]),
        act: (bloc) =>
            bloc.add(const InformationListInformationDeleted(information)),
        expect: () => const [
          InformationListState(
            status: InformationListStatus.loading,
            informationList: [information],
          ),
          InformationListState(
            status: InformationListStatus.failure,
            informationList: [information],
          ),
        ],
        verify: (_) {
          verify(() => informationRepository.deleteInformation(information.id!))
              .called(1);
          verify(() => informationRepository.deleteManyTexts([information.id!]))
              .called(1);
        },
      );
    });
  });
}
