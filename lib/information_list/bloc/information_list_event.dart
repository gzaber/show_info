part of 'information_list_bloc.dart';

sealed class InformationListEvent extends Equatable {
  const InformationListEvent();

  @override
  List<Object?> get props => [];
}

final class InformationListSubscriptionRequested extends InformationListEvent {
  const InformationListSubscriptionRequested();
}

final class InformationListInformationDeleted extends InformationListEvent {
  const InformationListInformationDeleted(this.information);

  final Information information;

  @override
  List<Object> get props => [information];
}
