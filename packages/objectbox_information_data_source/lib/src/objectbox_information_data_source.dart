import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox/objectbox.dart';

import 'entities/entities.dart';

class ObjectboxInformationDataSource implements InformationDataSource {
  ObjectboxInformationDataSource({required Store store}) : _store = store;

  final Store _store;

  @override
  Future<void> saveInformation(Information information) async {
    await _store
        .box<InformationEntity>()
        .putAsync(InformationEntity.fromModel(information));
  }

  @override
  Future<void> deleteInformation(int id) async {
    await _store.box<InformationEntity>().removeAsync(id);
  }

  @override
  Future<void> saveManyTexts(List<Text> texts) async {
    await _store
        .box<TextEntity>()
        .putManyAsync(texts.map((t) => TextEntity.fromModel(t)).toList());
  }

  @override
  Future<void> deleteManyTexts(List<int> ids) async {
    await _store.box<TextEntity>().removeManyAsync(ids);
  }

  @override
  Stream<List<Information>> readAllInformation() {
    return _store
        .box<InformationEntity>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find().map((info) => info.toModel()).toList());
  }
}
