import 'model/model.dart';

abstract interface class InformationDataSource {
  Future<void> saveInformation(Information information);
  Future<void> deleteInformation(int id);
  Stream<List<Information>> readAllInformation();
}
