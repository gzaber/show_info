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

final class AddEditInformationTextSelected extends AddEditInformationEvent {
  const AddEditInformationTextSelected(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

final class AddEditInformationTextChanged extends AddEditInformationEvent {
  const AddEditInformationTextChanged({
    this.content,
    this.fontSize,
    this.isBold,
    this.isItalic,
    this.isUnderline,
  });

  final String? content;
  final int? fontSize;
  final bool? isBold;
  final bool? isItalic;
  final bool? isUnderline;

  @override
  List<Object?> get props => [content, fontSize, isBold, isItalic, isUnderline];
}

final class AddEditInformationSubmitted extends AddEditInformationEvent {
  const AddEditInformationSubmitted();
}
