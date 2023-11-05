import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:information_repository/information_repository.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

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
        _ColorsModalBottomSheet.show(
          context: context,
          bloc: context.read<AddEditInformationBloc>(),
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

class _TextList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texts =
        context.select((AddEditInformationBloc bloc) => bloc.state.texts);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: texts.length,
      itemBuilder: (_, index) {
        return _SlidableListItem(index: index, text: texts[index]);
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
    return Slidable(
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
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              _TextStyleModalBottomSheet.show(
                context: context,
                bloc: context.read<AddEditInformationBloc>(),
                text: text,
                textIndex: index,
              );
            },
            icon: Icons.text_fields,
          ),
        ],
      ),
      child: _SlidableItemContent(text: text, index: index),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: text.fontSize.toDouble(),
          fontWeight: text.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: text.isItalic ? FontStyle.italic : FontStyle.normal,
          decoration:
              text.isUnderline ? TextDecoration.underline : TextDecoration.none,
        ),
        controller: TextEditingController(
          text: text.content,
        ),
        onChanged: (value) {
          context
              .read<AddEditInformationBloc>()
              .add(AddEditInformationTextChanged(index: index, content: value));
        },
      ),
    );
  }
}

class _ColorsModalBottomSheet extends StatelessWidget {
  const _ColorsModalBottomSheet({
    required this.colors,
    required this.bloc,
  });

  final List<int> colors;
  final AddEditInformationBloc bloc;

  static Future<void> show({
    required BuildContext context,
    required List<int> colors,
    required AddEditInformationBloc bloc,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return _ColorsModalBottomSheet(colors: colors, bloc: bloc);
        });
  }

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
                bloc.add(AddEditInformationColorChanged(color));
                Navigator.pop(context);
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

class _TextStyleModalBottomSheet extends StatefulWidget {
  const _TextStyleModalBottomSheet({
    required this.bloc,
    required this.text,
    required this.textIndex,
  });

  final AddEditInformationBloc bloc;
  final source.Text text;
  final int textIndex;

  static Future<void> show({
    required BuildContext context,
    required AddEditInformationBloc bloc,
    required source.Text text,
    required int textIndex,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (_) {
          return _TextStyleModalBottomSheet(
            bloc: bloc,
            text: text,
            textIndex: textIndex,
          );
        });
  }

  @override
  State<_TextStyleModalBottomSheet> createState() =>
      _TextStyleModalBottomSheetState();
}

class _TextStyleModalBottomSheetState
    extends State<_TextStyleModalBottomSheet> {
  late List<bool> selectedFormats;

  @override
  void initState() {
    selectedFormats = [
      widget.text.isBold,
      widget.text.isItalic,
      widget.text.isUnderline,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    selectedFormats[0] = !selectedFormats[0];
                    widget.bloc.add(AddEditInformationTextChanged(
                        index: widget.textIndex, isBold: selectedFormats[0]));
                  });
                case 1:
                  setState(() {
                    selectedFormats[1] = !selectedFormats[1];
                    widget.bloc.add(AddEditInformationTextChanged(
                        index: widget.textIndex, isItalic: selectedFormats[1]));
                  });
                default:
                  setState(() {
                    selectedFormats[2] = !selectedFormats[2];
                    widget.bloc.add(AddEditInformationTextChanged(
                        index: widget.textIndex,
                        isUnderline: selectedFormats[2]));
                  });
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
