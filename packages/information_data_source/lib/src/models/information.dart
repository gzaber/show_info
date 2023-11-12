import 'package:equatable/equatable.dart';

import '../models/models.dart';

class Information extends Equatable {
  const Information({
    this.id,
    required this.texts,
    required this.color,
  });

  final int? id;
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
  List<Object?> get props => [id, texts, color];
}
