import 'package:dev_framework_tutorial/src/app/app.dart';
import 'package:dev_framework_tutorial/src/bootstrap.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeApp();

  bootstrap(() => const App());
}
