import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:show_information/app/app.dart';
import 'package:show_information/information_list/information_list.dart';

import '../../helpers/helpers.dart';

void main() {
  late InformationRepository informationRepository;

  setUp(() {
    informationRepository = MockInformationRepository();
    when(() => informationRepository.readAllInformation())
        .thenAnswer((_) => const Stream.empty());
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(informationRepository: informationRepository),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders MaterialApp with correct themes', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: informationRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, equals(AppTheme().light));
      expect(materialApp.darkTheme, equals(AppTheme().dark));
    });

    testWidgets('renders InformationListPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: informationRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(InformationListPage), findsOneWidget);
    });
  });
}
