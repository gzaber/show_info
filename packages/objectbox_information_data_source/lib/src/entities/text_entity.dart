// ignore_for_file: must_be_immutable

import 'package:information_data_source/information_data_source.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TextEntity extends Equatable {
  TextEntity({
    required this.id,
    required this.content,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.isUnderline,
  });

  @Id()
  int id;
  final String content;
  final int fontSize;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;

  factory TextEntity.fromModel(Text text) {
    return TextEntity(
      id: text.id ?? 0,
      content: text.content,
      fontSize: text.fontSize,
      isBold: text.isBold,
      isItalic: text.isItalic,
      isUnderline: text.isUnderline,
    );
  }

  Text toModel() {
    return Text(
      id: id,
      content: content,
      fontSize: fontSize,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
    );
  }

  @override
  List<Object> get props {
    return [id, content, fontSize, isBold, isItalic, isUnderline];
  }
}
