import 'package:information_data_source/information_data_source.dart';
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockInformationDataSource extends Mock implements InformationDataSource {}

class FakeInformation extends Fake implements Information {}

void main() {
  group('InformationRepository', () {
    late InformationRepository informationRepository;
    late InformationDataSource mockDataSource;

    const text = Text(
      id: 1,
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );

    const information = Information(
      id: 1,
      texts: [text],
      color: 0xAB,
    );

    setUpAll(() {
      registerFallbackValue(FakeInformation());
    });

    setUp(() {
      mockDataSource = MockInformationDataSource();
      informationRepository = InformationRepository(dataSource: mockDataSource);
      when(() => mockDataSource.readAllInformation())
          .thenAnswer((_) => Stream.value([information]));
    });

    group('constructor', () {
      test('works properly', () {
        expect(
          () => InformationRepository(dataSource: mockDataSource),
          returnsNormally,
        );
      });
    });

    group('saveInformation', () {
      test('invokes proper data source method', () {
        when(() => mockDataSource.saveInformation(any()))
            .thenAnswer((_) async {});

        expect(informationRepository.saveInformation(information), completes);
        verify(() => mockDataSource.saveInformation(information)).called(1);
      });
    });

    group('deleteInformation', () {
      test('invokes proper data source method', () {
        when(() => mockDataSource.deleteInformation(any()))
            .thenAnswer((_) async {});

        expect(informationRepository.deleteInformation(1), completes);
        verify(() => mockDataSource.deleteInformation(1)).called(1);
      });
    });

    group('saveManyTexts', () {
      test('invokes proper data source method', () {
        when(() => mockDataSource.saveManyTexts(any()))
            .thenAnswer((_) async {});

        expect(informationRepository.saveManyTexts([text]), completes);
        verify(() => mockDataSource.saveManyTexts([text])).called(1);
      });
    });

    group('deleteManyTexts', () {
      test('invokes proper data source method', () {
        when(() => mockDataSource.deleteManyTexts(any()))
            .thenAnswer((_) async {});

        expect(informationRepository.deleteManyTexts([1, 2, 3]), completes);
        verify(() => mockDataSource.deleteManyTexts([1, 2, 3])).called(1);
      });
    });

    group('readAllInformation', () {
      test('invokes proper data source method', () {
        expect(informationRepository.readAllInformation(),
            isNot(throwsA(anything)));
        verify(() => mockDataSource.readAllInformation()).called(1);
      });

      test('returns stream of information', () {
        expect(
          informationRepository.readAllInformation(),
          emits([information]),
        );
      });
    });
  });
}
