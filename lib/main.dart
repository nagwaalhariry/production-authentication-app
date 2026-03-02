import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:production_authentication_app/app.dart';
import 'package:production_authentication_app/core/app_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // TODO: Send framework errors to Crashlytics/Sentry in production.
  };

  await runZonedGuarded(
    () async {
      // TODO: Configure FlutterFire using `flutterfire configure` and generated options.
      await Firebase.initializeApp();
      runApp(const App());
    },
    (error, stackTrace) {
      // TODO: Send uncaught zone errors to Crashlytics/Sentry in production.
      debugPrint('Uncaught zone error: $error');
      debugPrintStack(stackTrace: stackTrace);
    },
  );
}
