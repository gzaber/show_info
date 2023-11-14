import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:information_repository/information_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockInformationRepository extends Mock implements InformationRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    InformationRepository? informationRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: informationRepository ?? MockInformationRepository(),
        child: MaterialApp(
          home: Scaffold(body: widget),
        ),
      ),
    );
  }
}
