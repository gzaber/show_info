import 'package:flutter/material.dart';
import 'package:information_data_source/information_data_source.dart' as source;

class InformationPreviewPage extends StatelessWidget {
  const InformationPreviewPage({
    super.key,
    required this.information,
  });

  final source.Information information;

  static Route<void> route({required source.Information information}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/information_preview'),
      builder: (_) => InformationPreviewPage(information: information),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 10,
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            color: Color(information.color),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: information.texts.length,
              itemBuilder: (_, index) {
                final text = information.texts[index];
                return Text(
                  text.content,
                  style: TextStyle(
                    fontSize: text.fontSize.toDouble(),
                    fontWeight:
                        text.isBold ? FontWeight.bold : FontWeight.normal,
                    fontStyle:
                        text.isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: text.isUnderline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
