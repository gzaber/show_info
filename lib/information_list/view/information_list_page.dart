import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:information_repository/information_repository.dart';

import 'package:show_information/add_edit_information/add_edit_information.dart';
import 'package:show_information/app/app.dart';
import 'package:show_information/information_list/information_list.dart';
import 'package:show_information/information_preview/information_preview.dart';

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
        centerTitle: true,
        title: const Text(
          'ShowInformation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push<bool>(context, AddEditInformationPage.route());
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

  final List<source.Information> informationList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: informationList.length,
      itemBuilder: (_, index) {
        final information = informationList[index];
        return _SlidableListItem(information: information);
      },
    );
  }
}

class _SlidableListItem extends StatelessWidget {
  const _SlidableListItem({
    required this.information,
  });

  final source.Information information;

  @override
  Widget build(BuildContext context) {
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
            foregroundColor: AppColors.delete,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              Navigator.push<bool>(context,
                      AddEditInformationPage.route(information: information))
                  .then((isUpdated) {
                if (isUpdated == true) {
                  context
                      .read<InformationListBloc>()
                      .add(const InformationListSubscriptionRequested());
                }
              });
            },
            icon: Icons.edit,
            foregroundColor: AppColors.edit,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ],
      ),
      child: _SlidableItemContent(information: information),
    );
  }
}

class _SlidableItemContent extends StatelessWidget {
  const _SlidableItemContent({
    required this.information,
  });

  final source.Information information;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 10,
        color: Color(information.color),
      ),
      title: Text(
        information.texts.map((t) => t.content).join('\n'),
      ),
      onTap: () {
        Navigator.push(
            context, InformationPreviewPage.route(information: information));
      },
    );
  }
}
