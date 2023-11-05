part of 'add_edit_information_bloc.dart';

sealed class AddEditInformationEvent extends Equatable {
  const AddEditInformationEvent();

  @override
  List<Object?> get props => [];
}

final class AddEditInformationColorChanged extends AddEditInformationEvent {
  const AddEditInformationColorChanged(this.color);

  final int color;

  @override
  List<Object> get props => [color];
}

final class AddEditInformationNewTextAdded extends AddEditInformationEvent {
  const AddEditInformationNewTextAdded();
}

final class AddEditInformationTextDeleted extends AddEditInformationEvent {
  const AddEditInformationTextDeleted(this.text);

  final Text text;

  @override
  List<Object> get props => [text];
}

final class AddEditInformationTextChanged extends AddEditInformationEvent {
  const AddEditInformationTextChanged({
    required this.index,
    this.content,
    this.fontSize,
    this.isBold,
    this.isItalic,
    this.isUnderline,
  });

  final int index;
  final String? content;
  final int? fontSize;
  final bool? isBold;
  final bool? isItalic;
  final bool? isUnderline;

  @override
  List<Object?> get props =>
      [index, content, fontSize, isBold, isItalic, isUnderline];
}

final class AddEditInformationSubmitted extends AddEditInformationEvent {
  const AddEditInformationSubmitted();
}
