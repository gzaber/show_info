import 'package:flutter/material.dart';
import 'package:information_repository/information_repository.dart';
import 'package:objectbox_information_data_source/objectbox_information_data_source.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final docsDir = await getApplicationDocumentsDirectory();
  final store = await openStore(directory: p.join(docsDir.path, "app_store"));

  final informationDataSource = ObjectboxInformationDataSource(store: store);
  final informationRepository =
      InformationRepository(dataSource: informationDataSource);

  runApp(
    App(informationRepository: informationRepository),
  );
}
