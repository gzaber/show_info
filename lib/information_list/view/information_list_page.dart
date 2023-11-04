import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:information_repository/information_repository.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';
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
        onPressed: () {
          Navigator.push(context, AddEditInformationPage.route());
        },
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
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: state.informationList.length,
            itemBuilder: (_, index) {
              final information = state.informationList[index];
              return Slidable(
                startActionPane: ActionPane(
                  extentRatio: 0.2,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        context
                            .read<InformationListBloc>()
                            .add(InformationListDeletionRequested(information));
                      },
                      icon: Icons.delete,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  extentRatio: 0.2,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        Navigator.push(
                            context,
                            AddEditInformationPage.route(
                                information: information));
                      },
                      icon: Icons.edit,
                    ),
                  ],
                ),
                child: ListTile(
                  leading:
                      CircleAvatar(backgroundColor: Color(information.color)),
                  title: Text(
                    information.texts.map((t) => t.content).join('\n'),
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
