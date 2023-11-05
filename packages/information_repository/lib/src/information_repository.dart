import 'package:information_data_source/information_data_source.dart';

class InformationRepository {
  InformationRepository({required InformationDataSource dataSource})
      : _dataSource = dataSource;

  final InformationDataSource _dataSource;

  Future<void> saveInformation(Information information) async =>
      await _dataSource.saveInformation(information);

  Future<void> saveText(Text text) async => await _dataSource.saveText(text);

  Future<void> deleteInformation(int id) async =>
      await _dataSource.deleteInformation(id);

  Future<void> deleteText(int id) async => await _dataSource.deleteText(id);

  Stream<List<Information>> readAllInformation() =>
      _dataSource.readAllInformation();
}
