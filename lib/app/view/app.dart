import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:information_repository/information_repository.dart';

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
      home: Container(),
    );
  }
}
