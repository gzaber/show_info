import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:information_repository/information_repository.dart';
import 'package:show_information/information_list/information_list.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required InformationRepository informationRepository,
  }) : _informationRepository = informationRepository;

  final InformationRepository _informationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _informationRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShowInformation',
      themeMode: ThemeMode.light,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const InformationListPage(),
    );
  }
}
