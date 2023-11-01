import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:information_data_source/information_data_source.dart' hide Text;
import 'package:information_repository/information_repository.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

class AddEditInformationPage extends StatelessWidget {
  const AddEditInformationPage({super.key});

  static Route route({Information? information}) {
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
          Navigator.of(context).pop();
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
    final state = context.watch<AddEditInformationBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.initialInformation == null ? 'Create' : 'Update',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<AddEditInformationBloc>()
                  .add(const AddEditInformationSubmitted());
            },
            icon: state.status == AddEditInformationStatus.loading
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<AddEditInformationBloc>()
              .add(const AddEditInformationNewTextAdded());
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: state.texts.length,
        itemBuilder: (_, index) {
          return _TextFieldListItem(index: index);
        },
      ),
    );
  }
}

class _TextFieldListItem extends StatelessWidget {
  const _TextFieldListItem({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        decoration: const InputDecoration(border: OutlineInputBorder()),
        controller: TextEditingController(
          text:
              context.read<AddEditInformationBloc>().state.texts[index].content,
        ),
        onTap: () {
          context
              .read<AddEditInformationBloc>()
              .add(AddEditInformationTextSelected(index));
        },
        onChanged: (value) {
          context
              .read<AddEditInformationBloc>()
              .add(AddEditInformationTextChanged(content: value));
        },
      ),
    );
  }
}
