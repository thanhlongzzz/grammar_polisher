import 'package:flutter/material.dart';

import 'app.dart';
import 'configs/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI().init();
  runApp(const App());
}