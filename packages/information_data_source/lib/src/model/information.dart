import 'package:equatable/equatable.dart';

import '../model/model.dart';

class Information extends Equatable {
  Information({
    this.id = 0,
    required this.texts,
    this.color = 0,
  });

  final int id;
  final List<Text> texts;
  final int color;

  Information copyWith({
    int? id,
    List<Text>? texts,
    int? color,
  }) {
    return Information(
      id: id ?? this.id,
      texts: texts ?? this.texts,
      color: color ?? this.color,
    );
  }

  @override
  List<Object> get props => [id, texts, color];
}
