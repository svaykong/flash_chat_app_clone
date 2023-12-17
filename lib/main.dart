import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'root_app.dart';
import 'utils/get_di.dart' as di;

void main() async {
  // call this first for ensure everything is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // register all dependency injection here
  await di.init();

  // firebase initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RootApp());
}
