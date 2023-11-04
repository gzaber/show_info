import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:information_repository/information_repository.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

class AddEditInformationPage extends StatelessWidget {
  const AddEditInformationPage({super.key});

  static Route route({source.Information? information}) {
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
          Navigator.pop(context);
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
      body: _InformationList(),
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
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return _ColorsBottomSheetContent(
                onColorTap: (value) {
                  context
                      .read<AddEditInformationBloc>()
                      .add(AddEditInformationColorChanged(value));
                },
                colors: [
                  Colors.pink.value,
                  Colors.red.value,
                  Colors.orange.value,
                  Colors.amber.value,
                  Colors.yellow.value,
                  Colors.lime.value,
                  Colors.lightGreen.value,
                  Colors.green.value,
                  Colors.teal.value,
                  Colors.cyan.value,
                  Colors.lightBlue.value,
                  Colors.blue.value,
                  Colors.indigo.value,
                  Colors.purple.value,
                  Colors.deepPurple.value,
                  Colors.blueGrey.value,
                  Colors.brown.value,
                  Colors.grey.value,
                ],
              );
            });
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
          ? const CircularProgressIndicator.adaptive()
          : const Icon(Icons.save),
    );
  }
}

class _InformationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texts =
        context.select((AddEditInformationBloc bloc) => bloc.state.texts);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: texts.length,
      itemBuilder: (_, index) {
        return _TextFieldListItem(index: index, text: texts[index]);
      },
    );
  }
}

class _TextFieldListItem extends StatelessWidget {
  const _TextFieldListItem({
    required this.index,
    required this.text,
  });

  final int index;
  final source.Text text;

  @override
  Widget build(BuildContext context) {
    // final text = context
    //     .select((AddEditInformationBloc bloc) => bloc.state.texts[index]);

    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              context
                  .read<AddEditInformationBloc>()
                  .add(AddEditInformationTextDeleted(index));
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
              // context
              //     .read<AddEditInformationBloc>()
              //     .add(AddEditInformationTextSelected(index));
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return _TextStyleBottomSheetContent(
                    text: text,
                    onBoldChanged: () {
                      context.read<AddEditInformationBloc>().add(
                          AddEditInformationTextChanged(
                              index: index, isBold: !text.isBold));
                    },
                    onItalicChanged: () {
                      context.read<AddEditInformationBloc>().add(
                          AddEditInformationTextChanged(
                              index: index, isItalic: !text.isItalic));
                    },
                    onUnderlineChanged: () {
                      context.read<AddEditInformationBloc>().add(
                          AddEditInformationTextChanged(
                              index: index, isUnderline: !text.isUnderline));
                    },
                  );
                },
              );
            },
            icon: Icons.text_fields,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            fontSize: text.fontSize.toDouble(),
            fontWeight: text.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: text.isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: text.isUnderline
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          controller: TextEditingController(
            text: text.content,
          ),
          // onTap: () {
          //   context
          //       .read<AddEditInformationBloc>()
          //       .add(AddEditInformationTextSelected(index));
          // },
          onChanged: (value) {
            context.read<AddEditInformationBloc>().add(
                AddEditInformationTextChanged(index: index, content: value));
          },
        ),
      ),
    );
  }
}

class _ColorsBottomSheetContent extends StatelessWidget {
  const _ColorsBottomSheetContent({
    required this.colors,
    required this.onColorTap,
  });

  final List<int> colors;
  final Function(int) onColorTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          ...colors.map(
            (color) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onColorTap(color);
              },
              child: CircleAvatar(
                backgroundColor: Color(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextStyleBottomSheetContent extends StatelessWidget {
  const _TextStyleBottomSheetContent({
    required this.text,
    required this.onBoldChanged,
    required this.onItalicChanged,
    required this.onUnderlineChanged,
  });

  final source.Text text;
  final Function() onBoldChanged;
  final Function() onItalicChanged;
  final Function() onUnderlineChanged;

  @override
  Widget build(BuildContext context) {
    final selectedFormats = [text.isBold, text.isItalic, text.isUnderline];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.text_decrease),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.text_increase),
          ),
          ToggleButtons(
            isSelected: selectedFormats,
            onPressed: (index) {
              switch (index) {
                case 0:
                  onBoldChanged();
                case 1:
                  onItalicChanged();
                default:
                  onUnderlineChanged();
              }
            },
            children: const [
              Icon(Icons.format_bold),
              Icon(Icons.format_italic),
              Icon(Icons.format_underline)
            ],
          ),
        ],
      ),
    );
  }
}
