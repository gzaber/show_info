import 'package:information_data_source/information_data_source.dart';

class InformationRepository {
  InformationRepository({required InformationDataSource dataSource})
      : _dataSource = dataSource;

  final InformationDataSource _dataSource;

  Future<void> saveInformation(Information information) async =>
      await _dataSource.saveInformation(information);

  Future<void> deleteInformation(int id) async =>
      await _dataSource.deleteInformation(id);

  Future<void> saveManyTexts(List<Text> texts) async =>
      await _dataSource.saveManyTexts(texts);

  Future<void> deleteManyTexts(List<int> ids) async =>
      await _dataSource.deleteManyTexts(ids);

  Stream<List<Information>> readAllInformation() =>
      _dataSource.readAllInformation();
}
