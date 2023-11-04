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
    InformationListStatus Function()? status,
    List<Information> Function()? informationList,
  }) {
    return InformationListState(
      status: status != null ? status() : this.status,
      informationList:
          informationList != null ? informationList() : this.informationList,
    );
  }

  @override
  List<Object> get props => [status, informationList];
}
