import 'package:information_data_source/information_data_source.dart';

import 'entities.dart';

extension TextEntityToModelMapping on TextEntity {
  Text toModel() {
    return Text(
      id: id,
      content: content ?? "",
      fontSize: fontSize ?? 20,
      isBold: isBold ?? false,
      isItalic: isItalic ?? false,
      isUnderline: isUnderline ?? false,
    );
  }
}

extension TextModelToEntityMapping on Text {
  TextEntity toEntity() {
    return TextEntity(
      id: id,
      content: content,
      fontSize: fontSize,
      isBold: isBold,
      isItalic: isItalic,
      isUnderline: isUnderline,
    );
  }
}

extension InformationEntityToModelMapping on InformationEntity {
  Information toModel() {
    return Information(
      id: id,
      texts: texts.map((t) => t.toModel()).toList(),
      color: color ?? 0,
    );
  }
}

extension InformationModelToEntityMapping on Information {
  InformationEntity toEntity() {
    return InformationEntity(
      id: id,
      texts: texts.map((t) => t.toEntity()).toList(),
      color: color,
    );
  }
}
