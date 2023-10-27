import 'package:equatable/equatable.dart';

class Text extends Equatable {
  Text({
    this.id = 0,
    required this.content,
    this.fontSize = 20,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
  });

  final int id;
  final String content;
  final int fontSize;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;

  Text copyWith({
    int? id,
    String? content,
    int? fontSize,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
  }) {
    return Text(
      id: id ?? this.id,
      content: content ?? this.content,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
    );
  }

  @override
  List<Object> get props =>
      [id, content, fontSize, isBold, isItalic, isUnderline];
}
