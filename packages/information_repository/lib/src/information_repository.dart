import 'package:information_data_source/information_data_source.dart';

class InformationRepository {
  InformationRepository({required InformationDataSource dataSource})
      : _dataSource = dataSource;

  final InformationDataSource _dataSource;

  Future<void> save(Information information) async =>
      await _dataSource.saveInformation(information);

  Future<void> delete(int id) async => await _dataSource.deleteInformation(id);

  Stream<List<Information>> readAll() => _dataSource.readAllInformation();
}
