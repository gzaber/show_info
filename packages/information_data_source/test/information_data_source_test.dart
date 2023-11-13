import 'package:information_data_source/src/information_data_source.dart';
import 'package:test/test.dart';

class TestInformationDataSource implements InformationDataSource {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('InformationDataSource', () {
    test('can be constructed', () {
      expect(TestInformationDataSource.new, returnsNormally);
    });
  });
}
