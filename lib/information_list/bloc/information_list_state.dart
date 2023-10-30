part of 'information_list_bloc.dart';

enum InformationListStatus { initial, loading, success, failure }

class InformationListState extends Equatable {
  const InformationListState({
    this.status = InformationListStatus.initial,
    this.informationList = const [],
  });

  final InformationListStatus status;
  final List<Information> informationList;

  InformationListState copyWith({
    InformationListStatus? status,
    List<Information>? informationList,
  }) {
    return InformationListState(
      status: status ?? this.status,
      informationList: informationList ?? this.informationList,
    );
  }

  @override
  List<Object> get props => [status, informationList];
}
