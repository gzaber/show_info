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
  Future<void> saveText(Text text) async {
    await _store.box<TextEntity>().putAsync(TextEntity.fromModel(text));
  }

  @override
  Future<void> deleteInformation(int id) async {
    await _store.box<InformationEntity>().removeAsync(id);
  }

  @override
  Future<void> deleteText(int id) async {
    await _store.box<TextEntity>().removeAsync(id);
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
