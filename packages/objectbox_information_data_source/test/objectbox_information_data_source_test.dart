import 'package:flutter_test/flutter_test.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_information_data_source/objectbox_information_data_source.dart';
import 'package:objectbox_information_data_source/src/entities/entities.dart';

class MockStore extends Mock implements Store {}

class MockInformationBox extends Mock implements Box<InformationEntity> {}

class MockTextBox extends Mock implements Box<TextEntity> {}

class MockQueryBuilder extends Mock
    implements QueryBuilder<InformationEntity> {}

class MockQuery extends Mock implements Query<InformationEntity> {}

class FakeInformationEntity extends Fake implements InformationEntity {}

void main() {
  group('ObjectboxInformationDataSource', () {
    late ObjectboxInformationDataSource dataSource;
    late Store mockStore;
    late Box<InformationEntity> mockInformationBox;
    late Box<TextEntity> mockTextBox;

    const text1 = Text(
      id: 1,
      content: 'content',
      fontSize: 20,
      isBold: false,
      isItalic: false,
      isUnderline: false,
    );

    final text2 = text1.copyWith(id: 2);

    final information = Information(
      id: 1,
      texts: [text1, text2],
      color: 0xAB,
    );

    setUpAll(() {
      registerFallbackValue(FakeInformationEntity());
    });

    setUp(() {
      mockStore = MockStore();
      mockInformationBox = MockInformationBox();
      mockTextBox = MockTextBox();
      dataSource = ObjectboxInformationDataSource(
        store: mockStore,
        informationBox: mockInformationBox,
        textBox: mockTextBox,
      );
      when(() => mockStore.box<InformationEntity>())
          .thenAnswer((_) => mockInformationBox);
      when(() => mockStore.box<TextEntity>()).thenAnswer((_) => mockTextBox);
    });

    group('constructor', () {
      test('works properly when store is provided', () {
        expect(
          () => ObjectboxInformationDataSource(store: mockStore),
          returnsNormally,
        );
      });

      test('works properly when store and boxes are provided', () {
        expect(
          () => ObjectboxInformationDataSource(
            store: mockStore,
            informationBox: mockInformationBox,
            textBox: mockTextBox,
          ),
          returnsNormally,
        );
      });
    });

    group('saveInformation', () {
      test('saves information into database', () {
        when(() => mockInformationBox.putAsync(any()))
            .thenAnswer((_) async => 1);

        expect(dataSource.saveInformation(information), completes);

        verify(() => mockInformationBox
            .putAsync(any(that: isA<InformationEntity>()))).called(1);
      });
    });

    group('deleteInformation', () {
      test('deletes information from database', () {
        when(() => mockInformationBox.removeAsync(any()))
            .thenAnswer((_) async => true);

        expect(dataSource.deleteInformation(1), completes);

        verify(() => mockInformationBox.removeAsync(1)).called(1);
      });
    });

    group('saveManyTexts', () {
      test('saves list of texts into database', () {
        when(() => mockTextBox.putManyAsync(any()))
            .thenAnswer((_) async => [1, 2]);

        expect(dataSource.saveManyTexts([text1, text2]), completes);

        verify(() =>
                mockTextBox.putManyAsync(any(that: isA<List<TextEntity>>())))
            .called(1);
      });
    });

    group('deleteManyTexts', () {
      test('deletes list of texts from database', () {
        when(() => mockTextBox.removeManyAsync(any()))
            .thenAnswer((_) async => 2);

        expect(dataSource.deleteManyTexts([1, 2]), completes);

        verify(() => mockTextBox.removeManyAsync([1, 2])).called(1);
      });
    });

    group('readAllInformation', () {
      late QueryBuilder<InformationEntity> mockQueryBuilder;
      late Query<InformationEntity> mockQuery;

      setUp(() {
        mockQueryBuilder = MockQueryBuilder();
        mockQuery = MockQuery();
      });

      test('returns stream of all information', () {
        when(() => mockInformationBox.query())
            .thenAnswer((invocation) => mockQueryBuilder);
        when(() => mockQueryBuilder.watch(triggerImmediately: true))
            .thenAnswer((_) => Stream.value(mockQuery));
        when(() => mockQuery.find())
            .thenAnswer((_) => [InformationEntity.fromModel(information)]);

        expect(
          dataSource.readAllInformation(),
          emits([information]),
        );
      });
    });
  });
}
