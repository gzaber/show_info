import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:information_data_source/information_data_source.dart' hide Text;
import 'package:information_repository/information_repository.dart';
import 'package:show_information/information_list/information_list.dart';

class InformationListPage extends StatelessWidget {
  const InformationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InformationListBloc(
        informationRepository: context.read<InformationRepository>(),
      )..add(const InformationListSubscriptionRequested()),
      child: const InformationListView(),
    );
  }
}

class InformationListView extends StatelessWidget {
  const InformationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShowInformation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocConsumer<InformationListBloc, InformationListState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == InformationListStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong'),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == InformationListStatus.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state.informationList.isEmpty) {
            return const Center(
              child: Text('List is empty'),
            );
          }
          return _InformationList(informationList: state.informationList);
        },
      ),
    );
  }
}

class _InformationList extends StatelessWidget {
  const _InformationList({
    required this.informationList,
  });

  final List<Information> informationList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(
              '${informationList[index].texts.map((t) => t.content).toList()}'),
        );
      },
    );
  }
}
