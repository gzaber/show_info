import 'package:flutter/material.dart';
import 'package:information_data_source/information_data_source.dart' as source;
import 'package:show_information/add_edit_information/add_edit_information.dart';

class TextStyleSettingsModalBottomSheet extends StatefulWidget {
  const TextStyleSettingsModalBottomSheet({
    super.key,
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
          return TextStyleSettingsModalBottomSheet(
            bloc: bloc,
            text: text,
            textIndex: textIndex,
          );
        });
  }

  @override
  State<TextStyleSettingsModalBottomSheet> createState() =>
      _TextStyleSettingsModalBottomSheetState();
}

class _TextStyleSettingsModalBottomSheetState
    extends State<TextStyleSettingsModalBottomSheet> {
  late int fontSize;
  late List<bool> selectedFormats;

  @override
  void initState() {
    fontSize = widget.text.fontSize;
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
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              setState(() {
                widget.bloc.add(
                  AddEditInformationTextChanged(
                      index: widget.textIndex, fontSize: --fontSize),
                );
              });
            },
            child: const Icon(Icons.text_decrease),
          ),
          Text(
            '$fontSize',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                widget.bloc.add(
                  AddEditInformationTextChanged(
                      index: widget.textIndex, fontSize: ++fontSize),
                );
              });
            },
            child: const Icon(Icons.text_increase),
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
