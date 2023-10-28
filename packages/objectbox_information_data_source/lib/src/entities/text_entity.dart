import 'package:objectbox/objectbox.dart';

@Entity()
class TextEntity {
  TextEntity({
    this.id = 0,
    this.content,
    this.fontSize,
    this.isBold,
    this.isItalic,
    this.isUnderline,
  });

  @Id()
  int id;
  String? content;
  int? fontSize;
  bool? isBold;
  bool? isItalic;
  bool? isUnderline;
}
