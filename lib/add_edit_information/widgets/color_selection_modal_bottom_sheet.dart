import 'package:flutter/material.dart';
import 'package:show_information/add_edit_information/add_edit_information.dart';

class ColorSelectionModalBottomSheet extends StatelessWidget {
  const ColorSelectionModalBottomSheet({
    super.key,
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
          return ColorSelectionModalBottomSheet(colors: colors, bloc: bloc);
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
