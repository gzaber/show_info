part of 'add_edit_information_bloc.dart';

enum AddEditInformationStatus { initial, loading, success, failure }

class AddEditInformationState extends Equatable {
  const AddEditInformationState({
    this.status = AddEditInformationStatus.initial,
    this.initialInformation,
    this.texts = const [],
    this.color = 0,
  });

  final AddEditInformationStatus status;
  final Information? initialInformation;
  final List<Text> texts;
  final int color;

  AddEditInformationState copyWith({
    AddEditInformationStatus? status,
    Information? initialInformation,
    List<Text>? texts,
    int? color,
  }) {
    return AddEditInformationState(
      status: status ?? this.status,
      initialInformation: initialInformation ?? this.initialInformation,
      texts: texts ?? this.texts,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [status, initialInformation, texts, color];
}
