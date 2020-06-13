import 'dart:async';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:lta_datamall_flutter/ui/views/bus/bus_view.dart';

Future<void> main() async {
  Level logLevel;
  if (foundation.kReleaseMode) {
    logLevel = Level.WARNING;
  } else {
    logLevel = Level.ALL;
  }
  Logger.root.level = logLevel;
  Logger.root.onRecord.listen((record) {
    print(
        '[${record.loggerName}]: ${record.level.name}: ${record.time}: ${record.message}');
  });

  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    WidgetsFlutterBinding.ensureInitialized();
    // unawaited(DatabaseProvider.dbProvider.database);
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'SG Land Transport',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: BusView(),
    );
  }
}
