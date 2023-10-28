import 'package:objectbox/objectbox.dart';

import '../entities/entities.dart';

@Entity()
class InformationEntity {
  InformationEntity({
    this.id = 0,
    List<TextEntity>? texts,
    this.color,
  }) : texts = ToMany<TextEntity>(items: texts);

  @Id()
  int id;
  final ToMany<TextEntity> texts;
  int? color;
}
