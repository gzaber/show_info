import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:information_repository/information_repository.dart';

part 'add_edit_information_event.dart';
part 'add_edit_information_state.dart';

class AddEditInformationBloc
    extends Bloc<AddEditInformationEvent, AddEditInformationState> {
  AddEditInformationBloc({
    required InformationRepository informationRepository,
    required Information? initialInformation,
  })  : _informationRepository = informationRepository,
        super(
          AddEditInformationState(
            initialInformation: initialInformation,
            texts: initialInformation?.texts ?? const [],
            color: initialInformation?.color ?? 0xFF673AB7,
          ),
        ) {
    on<AddEditInformationColorChanged>(_addEditInformationColorChanged);
    on<AddEditInformationNewTextAdded>(_addEditInformationNewTextAdded);
    on<AddEditInformationTextDeleted>(_addEditInformationTextDeleted);
    on<AddEditInformationTextChanged>(_addEditInformationTextChanged);
    on<AddEditInformationSubmitted>(_addEditInformationSubmitted);
  }

  final InformationRepository _informationRepository;

  void _addEditInformationColorChanged(
    AddEditInformationColorChanged event,
    Emitter<AddEditInformationState> emit,
  ) {
    emit(state.copyWith(color: event.color));
  }

  void _addEditInformationNewTextAdded(
    AddEditInformationNewTextAdded event,
    Emitter<AddEditInformationState> emit,
  ) {
    final texts = [
      ...state.texts,
      const Text(
        id: 0,
        content: '',
        fontSize: 16,
        isBold: false,
        isItalic: false,
        isUnderline: false,
      ),
    ];
    emit(state.copyWith(texts: texts));
  }

  void _addEditInformationTextDeleted(
    AddEditInformationTextDeleted event,
    Emitter<AddEditInformationState> emit,
  ) {
    var texts = state.texts.toList();
    texts.remove(event.text);
    var textsToDelete = [...state.textsToDelete, event.text];
    emit(state.copyWith(texts: texts, textsToDelete: textsToDelete));
  }

  void _addEditInformationTextChanged(
    AddEditInformationTextChanged event,
    Emitter<AddEditInformationState> emit,
  ) {
    var texts = state.texts.toList();
    texts[event.index] = texts.elementAt(event.index).copyWith(
          content: event.content,
          fontSize: event.fontSize,
          isBold: event.isBold,
          isItalic: event.isItalic,
          isUnderline: event.isUnderline,
        );
    emit(state.copyWith(texts: texts));
  }

  Future<void> _addEditInformationSubmitted(
    AddEditInformationSubmitted event,
    Emitter<AddEditInformationState> emit,
  ) async {
    emit(state.copyWith(status: AddEditInformationStatus.loading));
    final information = (state.initialInformation ??
            const Information(id: 0, texts: [], color: 0))
        .copyWith(
      texts: state.texts,
      color: state.color,
    );

    try {
      await _informationRepository.saveInformation(information);
      for (final text in information.texts) {
        if (text.id != 0) {
          await _informationRepository.saveText(text);
        }
      }
      for (final text in state.textsToDelete) {
        if (text.id != 0) {
          await _informationRepository.deleteText(text.id);
        }
      }
      emit(state.copyWith(status: AddEditInformationStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddEditInformationStatus.failure));
    }
  }
}
