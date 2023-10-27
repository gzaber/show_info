import 'model/model.dart';

abstract interface class InformationDataSource {
  Future<void> createInformation(Information information);
  Future<void> updateInformation(Information information);
  Future<void> deleteInformation(int id);
  Stream<List<Information>> readAllInformation();
}
