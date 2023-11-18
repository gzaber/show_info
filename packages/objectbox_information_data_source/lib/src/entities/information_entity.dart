// ignore_for_file: must_be_immutable

import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox/objectbox.dart';

import '../entities/entities.dart';

@Entity()
class InformationEntity extends Equatable {
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
      id: information.id ?? 0,
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

  @override
  List<Object> get props => [id, texts, color];
}
