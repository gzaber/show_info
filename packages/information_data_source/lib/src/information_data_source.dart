import 'models/models.dart';

abstract interface class InformationDataSource {
  Future<void> saveInformation(Information information);
  Future<void> saveText(Text text);
  Future<void> deleteInformation(int id);
  Future<void> deleteText(int ind);
  Stream<List<Information>> readAllInformation();
}
