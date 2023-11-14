import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox/objectbox.dart';

import 'entities/entities.dart';

class ObjectboxInformationDataSource implements InformationDataSource {
  ObjectboxInformationDataSource({
    required Store store,
    Box<InformationEntity>? informationBox,
    Box<TextEntity>? textBox,
  })  : _informationBox = informationBox ?? store.box<InformationEntity>(),
        _textBox = textBox ?? store.box<TextEntity>();

  final Box<InformationEntity> _informationBox;
  final Box<TextEntity> _textBox;

  @override
  Future<void> saveInformation(Information information) async {
    await _informationBox.putAsync(InformationEntity.fromModel(information));
  }

  @override
  Future<void> deleteInformation(int id) async {
    await _informationBox.removeAsync(id);
  }

  @override
  Future<void> saveManyTexts(List<Text> texts) async {
    await _textBox
        .putManyAsync(texts.map((t) => TextEntity.fromModel(t)).toList());
  }

  @override
  Future<void> deleteManyTexts(List<int> ids) async {
    await _textBox.removeManyAsync(ids);
  }

  @override
  Stream<List<Information>> readAllInformation() {
    return _informationBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find().map((info) => info.toModel()).toList());
  }
}
