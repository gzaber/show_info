import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox/objectbox.dart';

import '../entities/entities.dart';

@Entity()
class InformationEntity {
  InformationEntity({
    required this.id,
    required this.texts,
    required this.color,
  });

  @Id()
  int id;
  final ToMany<TextEntity> texts;
  final int color;

  factory InformationEntity.fromModel(Information information) {
    return InformationEntity(
      id: information.id,
      texts: ToMany<TextEntity>(
        items: information.texts.map((t) => TextEntity.fromModel(t)).toList(),
      ),
      color: information.color,
    );
  }

  Information toModel() {
    return Information(
      id: id,
      texts: texts.map((t) => t.toModel()).toList(),
      color: color,
    );
  }
}
