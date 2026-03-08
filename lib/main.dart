import 'dart:async';
import 'dart:ui';

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

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    // TODO: Send uncaught async errors to Crashlytics/Sentry in production.
    debugPrint('Uncaught platform error: $error');
    debugPrintStack(stackTrace: stackTrace);
    return true;
  };

  runApp(const App());
}
