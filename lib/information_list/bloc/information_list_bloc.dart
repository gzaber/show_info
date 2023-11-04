import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:information_data_source/information_data_source.dart';
import 'package:information_repository/information_repository.dart';

part 'information_list_event.dart';
part 'information_list_state.dart';

class InformationListBloc
    extends Bloc<InformationListEvent, InformationListState> {
  InformationListBloc({
    required InformationRepository informationRepository,
  })  : _informationRepository = informationRepository,
        super(const InformationListState()) {
    on<InformationListSubscriptionRequested>(_onSubscriptionRequested);
    on<InformationListDeletionRequested>(_onDeletionRequested);
  }

  final InformationRepository _informationRepository;

  Future<void> _onSubscriptionRequested(
    InformationListSubscriptionRequested event,
    Emitter<InformationListState> emit,
  ) async {
    emit(state.copyWith(status: () => InformationListStatus.loading));

    await emit.forEach<List<Information>>(
      _informationRepository.readAll(),
      onData: (informationList) => state.copyWith(
        status: () => InformationListStatus.success,
        informationList: () {
          print(informationList);
          return informationList;
        },
      ),
      onError: (_, __) => state.copyWith(
        status: () => InformationListStatus.failure,
      ),
    );
  }

  Future<void> _onDeletionRequested(
    InformationListDeletionRequested event,
    Emitter<InformationListState> emit,
  ) async {
    emit(state.copyWith(status: () => InformationListStatus.loading));
    try {
      await _informationRepository.delete(event.information.id);
    } catch (e) {
      emit(state.copyWith(status: () => InformationListStatus.failure));
    }
    emit(state.copyWith(status: () => InformationListStatus.success));
  }
}
