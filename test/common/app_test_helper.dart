// Contains the support code (objects, functions, constants, variables)
// used for the testing of this particular app

import 'package:dev_framework_tutorial/src/common/helper.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/bloc/notes_bloc.dart';
import 'package:dev_framework_tutorial/src/features/notes/presentation/main/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

extension ItgAppAddedFunctionality on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
          home: Scaffold(body: widget),
        ),
    );
  }

  Future<void> pumpRoute(Route<dynamic> route) {
    // TODO: I could use also pumpBasicMaterialAppWithWidget...
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
    );
  }

  Future<void> pumpNotesList(NotesBloc bloc) async {
    itgLogVerbose('WidgetTester.pumpNotesList - start...');
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          // child: const NotesList(),
          child: const NotesView(),
        ),
      ),
    );
  }
}

