import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:information_repository/information_repository.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';
import 'package:show_information/app/app.dart';

class AddEditInformationPage extends StatelessWidget {
  const AddEditInformationPage({super.key});

  static Route<bool> route({source.Information? information}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/add_edit_information'),
      builder: (_) => BlocProvider(
        create: (context) => AddEditInformationBloc(
          informationRepository: context.read<InformationRepository>(),
          initialInformation: information,
        ),
        child: const AddEditInformationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEditInformationBloc, AddEditInformationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddEditInformationStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Something went wrong'),
              ),
            );
        }
        if (state.status == AddEditInformationStatus.success) {
          Navigator.pop(context, true);
        }
      },
      child: const AddEditInformationView(),
    );
  }
}

class AddEditInformationView extends StatelessWidget {
  const AddEditInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.read<AddEditInformationBloc>().state.initialInformation ==
                  null
              ? 'Create'
              : 'Update',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          _SelectColorButton(),
          _SaveButton(),
        ],
      ),
      body: _TextList(),
    );
  }
}

class _SelectColorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color =
        context.select((AddEditInformationBloc bloc) => bloc.state.color);

    return IconButton(
      onPressed: () {
        ColorSelectionModalBottomSheet.show(
          context: context,
          bloc: context.read<AddEditInformationBloc>(),
          colors: AppColors.colors,
        );
      },
      icon: CircleAvatar(
        backgroundColor: Color(color == 0 ? Colors.indigo.value : color),
        radius: 12,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status =
        context.select((AddEditInformationBloc bloc) => bloc.state.status);

    return IconButton(
      onPressed: () {
        context
            .read<AddEditInformationBloc>()
            .add(const AddEditInformationSubmitted());
      },
      icon: status == AddEditInformationStatus.loading
          ? const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator.adaptive(),
            )
          : const Icon(Icons.save),
    );
  }
}

class _TextList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texts =
        context.select((AddEditInformationBloc bloc) => bloc.state.texts);

    return ListView.builder(
      itemCount: texts.length + 1,
      itemBuilder: (_, index) {
        if (index < texts.length) {
          return _SlidableListItem(index: index, text: texts[index]);
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: IconButton.outlined(
                onPressed: () {
                  context
                      .read<AddEditInformationBloc>()
                      .add(const AddEditInformationNewTextAdded());
                },
                icon: const Icon(Icons.add),
              ),
            ),
          );
        }
      },
    );
  }
}

class _SlidableListItem extends StatelessWidget {
  const _SlidableListItem({
    required this.index,
    required this.text,
  });

  final int index;
  final source.Text text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                context
                    .read<AddEditInformationBloc>()
                    .add(AddEditInformationTextDeleted(text));
              },
              icon: Icons.delete,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                TextStyleSettingsModalBottomSheet.show(
                  context: context,
                  bloc: context.read<AddEditInformationBloc>(),
                  text: text,
                  textIndex: index,
                );
              },
              icon: Icons.text_fields,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ],
        ),
        child: _SlidableItemContent(text: text, index: index),
      ),
    );
  }
}

class _SlidableItemContent extends StatelessWidget {
  const _SlidableItemContent({
    required this.text,
    required this.index,
  });

  final source.Text text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        key: UniqueKey(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),
        style: TextStyle(
          fontSize: text.fontSize.toDouble(),
          fontWeight: text.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: text.isItalic ? FontStyle.italic : FontStyle.normal,
          decoration:
              text.isUnderline ? TextDecoration.underline : TextDecoration.none,
        ),
        initialValue: text.content,
        onChanged: (value) {
          context
              .read<AddEditInformationBloc>()
              .add(AddEditInformationTextChanged(index: index, content: value));
        },
      ),
    );
  }
}
