import 'models/models.dart';

abstract interface class InformationDataSource {
  Future<void> saveInformation(Information information);
  Future<void> deleteInformation(int id);
  Future<void> saveManyTexts(List<Text> texts);
  Future<void> deleteManyTexts(List<int> ids);
  Stream<List<Information>> readAllInformation();
}
