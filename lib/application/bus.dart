import 'package:eat_in_cczu/application/config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ApplicationBus {
  AppConfig config;
  Logger logger;
  ApplicationBus(this.config, this.logger);
}

AppConfig config({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
          context ?? globalApplicationKey.currentState!.overlay!.context,
          listen: false)
      .config;
}

Logger logger({BuildContext? context}) {
  return Provider.of<ApplicationBus>(
          context ?? globalApplicationKey.currentState!.overlay!.context,
          listen: false)
      .logger;
}

final GlobalKey<NavigatorState> globalApplicationKey =
    GlobalKey<NavigatorState>();

Future<String> getAndroidPath() async {
  try {
    return (await getExternalStorageDirectory())!.path;
  } catch (exc) {
    return (await getApplicationSupportDirectory()).path;
  }
}
